**FREE
//=====================================================================*                 RADD
//  IFS2R02    - Tools/400: Stream File and Directory - Directory      *                 RADD
//=====================================================================*                 RADD
//  Author  :  Thomas Raddatz                                          *
//  Date    :  03.02.2009                                              *
//  E-mail  :  thomas.raddatz@Tools400.de                              *
//  Homepage:  www.tools400.de                                         *
//=====================================================================*
//                                                                     *
//  This software is free software, you can redistribute it and/or     *
//  modify it under the terms of the GNU General Public License (GPL)  *
//  as published by the Free Software Foundation.                      *
//                                                                     *
//  See GNU General Public License for details.                        *
//          http://www.opensource.org                                  *
//          http://www.opensource.org/licenses/gpl-license.html        *
//                                                                     *
//=====================================================================*
//  History:                                                           *
//                                                                     *
//  Datum       Name          Änderung                                 *
//  ----------  ------------  ---------------------------------------  *
//                                                                     *
// =================================================================== *
// >>PRE-COMPILER<<                                                    *
//   >>CRTCMD<< CRTRPGMOD    MODULE(&LI/&OB) +                         *
//                           SRCFILE(&SL/&SF) +                        *
//                           SRCMBR(&SM);                              *
//                                                                     *
//   >>COMPILE<<                                                       *
//     >>PARM<< DBGVIEW(*LIST);                                        *
//     >>PARM<< TRUNCNBR(*NO );                                        *
//     >>PARM<< TGTRLS(V7R3M0);                                        *
//   >>END-COMPILE<<                                                   *
//                                                                     *
//   >>EXECUTE<<                                                       *
//                                                                     *
// >>END-PRE-COMPILER<<                                                *
// =================================================================== *
CTL-OPT NOMAIN;
/COPY QIFS2,H_SPEC 
// =================================================================== *
//
// ------------------------------------
//  Exported prototypes
// ------------------------------------
/COPY QIFS2,PIFS2 
//
// ------------------------------------
//  Imported prototypes
// ------------------------------------
/COPY QIFS2,CEELIB  CEE APIs
/COPY QIFS2,PIFS2R04  App.Msg
/COPY QIFS2,PIFS2R05  Application
/COPY QIFS2,PIFS2R99  Miscellaneous
//
// ------------------------------------
//  Private prototypes
// ------------------------------------
//
//  Deletes all entries of a given directory and its subdirectories.
DCL-PR clearDirectory IND EXTPROC('clearDirectory');
  i_level     INT(10) CONST;
  i_directory CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  i_entry     CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  i_type      CONST LIKE(ifs_type_t);
  i_pUsrDta   POINTER CONST;
  o_msg       LIKE(msg_t);
END-PR;
//
// ------------------------------------
//  Type definitions
// ------------------------------------
/COPY QIFS2,TYPES 
//
//  'clearDirectory' user data
DCL-DS clrDirUsrDta_t QUALIFIED BASED(pDummy);
  options INT(10);
  numE    INT(10);
END-DS;
//
// ------------------------------------
//  Global constants
// ------------------------------------
//
// ------------------------------------
//  Global fields
// ------------------------------------
//
//=========================================================================
//  Returns cTrue if the specified directory exists, else cFalse.
//=========================================================================
//  Parameters:
//   i_directory   - The name of a given directory.
//
//  Returns:
//   doesExist     - Returns cTrue if the directory exists, else cFalse.
//=========================================================================
DCL-PROC ifsDirectory_exist EXPORT;
  //
  DCL-PI *N IND;
    i_directory CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    o_msg       LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;
  //
  //  Return value
  DCL-S doesExist IND INZ(cFalse);
  //
  //  Parameter positions
  DCL-C p_msg 2;
  //
  //  Helper fields
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  stat() result data structure
  DCL-DS st_stat LIKEDS(st_stat_t) INZ;
  //
/COPY QIFS2,IFS1034  Failed to retrieve directory informatio
  // ---------------------------------------------------------

  f_clrErrno();

  //If the object could not be found, ...
  if (stat(ifsPath_fixSyntax(i_directory): %addr(st_stat)) = RC_ERROR);
    //... check error code to ensure that it is 3025 "no such file or directory"
    if (f_errno() <> ENOENT_C);
      clear IFS1034;
      IFS10341 = i_directory;
      IFS10342 = f_errno();
      IFS10343 = f_strerror(f_errno());
      Application_killWithMsg(AppMsg_newEscape('IFS1034': IFS1034));
    endif;
    return cFalse;
  endif;

  //Ensure that the object is a directory and not a file.
  if (not STAT_isDirectory(st_stat));
    return cFalse;
  endif;

  return cTrue;

//
END-PROC;
//
//=========================================================================
//  Creates a new IFS directory.
//=========================================================================
//  Parameters:
//   i_directory   - Directory to create.
//   i_options     - Options:
//                   cIFS_MKDIR_DFT           Default settings.
//                   cIFS_MKDIR_SUBDIR        Create directories recursively
//   i_auth        - Authority. See: ifsFile_open()
//   o_msg         - Error message.
//
//  Returns:
//   rc            - Returns cIFS_OK on success, else cIFS_ERROR.
//=========================================================================
DCL-PROC ifsDirectory_create EXPORT;
  //
  DCL-PI *N INT(10);
    i_directory CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    i_options   INT(10) CONST OPTIONS(*NOPASS: *OMIT);
    i_auth      INT(10) CONST OPTIONS(*NOPASS: *OMIT);
    o_msg       LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;
  //
  //  Return value
  DCL-S rc INT(10) INZ(cIFS_ERROR);
  //
  //  Parameter positions
  DCL-C p_options 2;
  DCL-C p_auth 3;
  DCL-C p_msg 4;
  //
  //  Fields for optional parameters
  DCL-S options LIKE(i_options) INZ;
  DCL-S auth LIKE(i_auth) INZ;
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  Helper fields
  DCL-S x INT(10) INZ;
  DCL-S y INT(10) INZ;
  DCL-S directory LIKE(ifs_path_t) INZ;
  DCL-S homeDir LIKE(ifs_path_t) INZ;
  DCL-S newDir LIKE(ifs_path_t) INZ;
  DCL-S tmpAuth LIKE(auth) INZ;
  //
  //  stat() result data structure
  DCL-DS st_stat LIKEDS(st_stat_t) INZ;
  //
  //  Helper fields
  DCL-S isRecursion IND INZ(cFalse);
  //
/COPY QIFS2,IFS1024  Invalid path name.
/COPY QIFS2,IFS1025  Failed to retrieve permissions and ...
/COPY QIFS2,IFS1026  Failed to create directory '&1'.
/COPY QIFS2,IFS1027  Could not set permissions for directory
/COPY QIFS2,IFS1032  Directory '&1' already exists.
/COPY QIFS2,IFS1035  Failed to create directory '&1' ...
  // ---------------------------------------------------------

  //Process optional parameters ...
  //... i_options
  if (%parms() >= p_options and %addr(i_options) <> *NULL);
    options = i_options;
  else;
    options = cIFS_MKDIR_DFT;
  endif;

  //... i_auth
  if (%parms() >= p_auth and %addr(i_auth) <> *NULL);
    auth = i_auth;
  else;
    auth = -1;
  endif;

  //Clear error message
  msg = AppMsg_new(cMsg_ID_OK);

  dou '1';

    //Check whether the path has to be created recursively or not
    isRecursion = f_isBitOn(cIFS_MKDIR_SUBDIR: options);

    //Fix path (slashes)
    directory = ifsDirectory_fixSyntax(i_directory);

    //Ensure that the user did not specifiy the
    //root directory or an empty string.
    if (directory = cSLASH or %len(%trim(directory)) = 0);
      clear IFS1024;
      IFS10241 = i_directory;
      msg = AppMsg_newEscape('IFS1024': IFS1024);
      leave;
    endif;

    //Ensure that the directory does not already exist
    if (ifsDirectory_exist(directory));
      clear IFS1032;
      IFS10321 = i_directory;
      msg = AppMsg_newEscape('IFS1032': IFS1032);
      leave;
    endif;

    //Ensure that a file with the same name does not already exist
    if (ifsFile_exist(directory));
      clear IFS1035;
      IFS10351 = i_directory;
      msg = AppMsg_newEscape('IFS1035': IFS1035);
      leave;
    endif;

    //Create directory:
    if (f_startsWith(cSLASH: directory));
      x = %scan(cSLASH: directory: 2);
      homeDir = cSLASH;
    else;
      x = %scan(cSLASH: directory: 1);
      homeDir = '.';
    endif;

    dow (x <> 0);

      newDir = %subst(directory: 1: x);

      if ((isRecursion or x = %len(directory))
           and not ifsDirectory_exist(newDir));

        //Determine directory authorization
        if (auth < 0);
          rc = stat(homeDir: %addr(st_stat));
          if (rc = RC_ERROR);
            clear IFS1025;
            IFS10251 = homeDir;
            IFS10252 = f_errno();
            IFS10253 = f_strerror(f_errno());
            msg = AppMsg_newEscape('IFS1025': IFS1025);
            leave;
          endif;
        else;
          st_stat.mode = auth;
        endif;

        //Create directory
        tmpAuth = %bitand(st_stat.mode: S_IRWXU + S_IRWXG + S_IRWXO);
        rc = mkdir(newDir: tmpAuth);

        //If we got an error
        if (rc = RC_ERROR);
          //... then create error message
          clear IFS1026;
          IFS10261 = %trim(newDir);
          IFS10262 = f_errno();
          IFS10263 = f_strerror(f_errno());
          msg = AppMsg_newEscape('IFS1026': IFS1026);
          leave;
        endif;

        //Set bits for "effective user id", "effective group id" and
        //"restricted renames and unlinks"
        tmpAuth = %bitand(st_stat.mode: S_IRWXU + S_IRWXG + S_IRWXO +
                                        S_ISUID + S_ISGID + S_ISVTX);
        rc = chmod(newDir: tmpAuth);

        //If we got an error
        if (rc = RC_ERROR);
          //... then create error message
          clear IFS1027;
          IFS10271 = %trim(newDir);
          IFS10272 = f_errno();
          IFS10273 = f_strerror(f_errno());
          msg = AppMsg_newEscape('IFS1027': IFS1027);
          leave;
        endif;

      endif;

      homeDir = newDir;

      if (x < %len(directory));
        x = %scan(cSLASH: directory: x+1);
      else;
        x = 0;
      endif;
    enddo;

    rc = 0;
  enddo;

  //Ensure that message has been correctly set
  p_assert(msg.ID = cMsg_ID_OK or msg.type = cMsg_Escape);

  //If the message parameter was passed ...
  if (%parms() >= p_msg);
    //... and not omitted
    if (%addr(o_msg) <> *NULL);
      //Return back message
      o_msg = msg;
    endif;
  else;
    //... else send message
    if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
    endif;
  endif;

  return rc;

//
END-PROC;
//
//=========================================================================
//  Deletes a given directory.
//=========================================================================
//  Parameters:
//   i_directory   - Directory to delete.
//   i_options     - Options:
//                   cIFS_RMDIR_DFT           Default settings.
//                   cIFS_RMDIR_DELETE_SUB_DIRECTORIES Delete subdirectories.
//   o_msg         - Error message.
//
//  Returns:
//   rc            - Returns number of deleted files and directories
//                   on success, else cIFS_ERROR.
//=========================================================================
DCL-PROC ifsDirectory_remove EXPORT;
  //
  DCL-PI *N INT(10);
    i_directory CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    i_options   INT(10) CONST OPTIONS(*NOPASS: *OMIT);
    o_msg       LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;
  //
  //  Return value
  DCL-S rc INT(10) INZ(cIFS_ERROR);
  //
  //  Parameter positions
  DCL-C p_options 2;
  DCL-C p_msg 3;
  //
  //  Fields for optional parameters
  DCL-S options LIKE(i_options) INZ;
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  Helper fields
  DCL-S subDirOptions INT(10) INZ;
  DCL-S directory LIKE(ifs_path_t) INZ;
  //
  //  Helper fields
  DCL-S mustClearDirectory IND INZ(cFalse);
  DCL-DS tmpMsg LIKEDS(msg_t) INZ;
  //
  DCL-DS usrDta LIKEDS(clrDirUsrDta_t) INZ;
  //
/COPY QIFS2,IFS1024  Invalid path name.
/COPY QIFS2,IFS1031  Failed to delete IFS directory '&1'.
  // ---------------------------------------------------------

  //Process optional parameters ...
  //... i_options
  if (%parms() >= p_options and %addr(i_options) <> *NULL);
    options = i_options;
  else;
    options = cIFS_RMDIR_DFT;
  endif;

  //Clear error message
  msg = AppMsg_new(cMsg_ID_OK);

  dou '1';

    //Fix path (slashes)
    directory = ifsDirectory_fixSyntax(i_directory);

    //Check whether subdirectories must be deleted
    mustClearDirectory =
       f_isBitOn(cIFS_RMDIR_DELETE_SUB_DIRECTORIES: options);

    //Ensure that the user did not specifiy the
    //root directory or an empty string.
    if (directory = cSLASH or %len(%trim(directory)) = 0);
      clear IFS1024;
      IFS10241 = i_directory;
      msg = AppMsg_newEscape('IFS1024': IFS1024);
      rc = cIFS_ERROR;
      leave;
    endif;

    //Remove directory entries
    if (mustClearDirectory);
      subDirOptions = cIFS_READDIR_CB_NAME + cIFS_READDIR_POST_ORDER
                                           + cIFS_READDIR_DIRECTORY
                                           + cIFS_READDIR_FILE;

      usrDta.numE    = 0;
      usrDta.options = options;

      if (ifsDirectory_read(directory
                            : %paddr('clearDirectory')
                            : subDirOptions
                            : %addr(usrDta)
                            : tmpMsg) = cIFS_ERROR);
        msg = tmpMsg;
        rc = cIFS_ERROR;
        leave;
      endif;
    endif;

    //Delete directory
    if (rmDir(directory) <> 0);
      clear IFS1031;
      IFS10311 = directory;
      IFS10312 = f_errno();
      IFS10313 = f_strerror(f_errno());
      msg = AppMsg_newEscape('IFS1031': IFS1031);
      rc = cIFS_ERROR;
      leave;
    endif;

    rc = usrDta.numE + 1;
  enddo;

  //Ensure that message has been correctly set
  p_assert(msg.ID = cMsg_ID_OK or msg.type = cMsg_Escape);

  //If the message parameter was passed ...
  if (%parms() >= p_msg);
    //... and not omitted
    if (%addr(o_msg) <> *NULL);
      //Return back message
      o_msg = msg;
    endif;
  else;
    //... else send message
    if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
    endif;
  endif;

  return rc;

//
END-PROC;
//
//=========================================================================
//  Renames a given directory.
//=========================================================================
//  Parameters:
//   i_fromDirectory - Name of the directory that shall be renamed.
//   i_toDirectory   - New name of the directory.
//   o_msg           - Error message.
//
//  Returns:
//   rc            - Returns cIFS_OK on success, else CIFS_ERROR.
//=========================================================================
DCL-PROC ifsDirectory_rename EXPORT;
  //
  DCL-PI *N INT(10);
    i_fromDirectory CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    i_toDirectory   CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    o_msg           LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;
  //
  //  Return value
  DCL-S rc INT(10) INZ;
  //
  //  Parameter positions
  DCL-C p_msg 3;
  //
  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  Helper fields
  DCL-S tmpRC INT(10) INZ;
  DCL-S toPath LIKE(ifs_path_t) INZ;
  //
/COPY QIFS2,IFS1039  Failed to rename directory '&1' to '&2'
/COPY QIFS2,IFS1011  Directory '&1' does not exist.
/COPY QIFS2,IFS1032  Directory '&1' already exits.
/COPY QIFS2,IFS1038  Directory name '&1' contains invalid ..
  // ---------------------------------------------------------

  msg = AppMsg_new(cMsg_ID_OK);

  dou '1';

    //If the file does not exist, ...
    if (not ifsDirectory_exist(i_fromDirectory));
      //... then create an error message
      clear IFS1011;
      IFS10111 = i_fromDirectory;
      msg = AppMsg_newEscape('IFS1011': IFS1011);
      rc = cIFS_ERROR;
      leave;
    endif;

    //If the target file name contains a directory, ...
    if (not ifsPath_isNameOnly(i_toDirectory));
      //... then create error message
      rc = RC_ERROR;
      clear IFS1038;
      IFS10381 = %trim(i_toDirectory);
      msg = AppMsg_newEscape('IFS1038': IFS1038);
      rc = cIFS_ERROR;
      leave;
    endif;

    //Compute path of target file
    toPath = ifsPath_fixSyntax(
                ifsPath_getDirectory(i_fromDirectory) + i_toDirectory);

    //If the target file does already exist, ...
    if (ifsFile_exist(toPath));
      //... then create error message
      clear IFS1032;
      IFS10321 = toPath;
      msg = AppMsg_newEscape('IFS1032': IFS1032);
      rc = cIFS_ERROR;
      leave;
    endif;

    //Rename stream file
    tmpRC = Qp0lRenameKeep(ifsPath_fixSyntax(i_fromDirectory): toPath);

    //If we got an error, ...
    if (tmpRC = RC_ERROR);
      //... then create error message
      clear IFS1039;
      IFS10391 = i_fromDirectory;
      IFS10392 = i_toDirectory;
      IFS10393 = f_errno();
      IFS10394 = f_strerror(f_errno());
      msg = AppMsg_newEscape('IFS1039': IFS1039);
      rc = cIFS_ERROR;
      leave;
    endif;

    rc = cIFS_OK;
  enddo;

  //Ensure that message has been correctly set
  p_assert(msg.ID = cMsg_ID_OK or msg.type = cMsg_Escape);

  //If the message parameter was passed ...
  if (%parms() >= p_msg);
    //... and not omitted
    if (%addr(o_msg) <> *NULL);
      //Return back message
      o_msg = msg;
    endif;
  else;
    //... else send message
    if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
    endif;
  endif;

  return rc;

//
END-PROC;
//
//=========================================================================
//  Reads the entries of a given directory.
//=========================================================================
//  Parameters:
//   i_path        - The name of an IFS directory.
//                   Wildcard characters are: '*' and '?'.
//   i_pCallback   - Procdure pointer of callback procedure.
//                   The callback procedure is called for each entry
//                   that matches the search criteria.
//   i_options     - Options:                                   1) = Default settings
//                   cIFS_READDIR_DFT             default settings.
//                   cIFS_READDIR_FILE            list files.
//                   cIFS_READDIR_DIRECTORY       list directories.
//                   cIFS_READDIR_ALL             list all directory entries.
//                   cIFS_READDIR_CB_NAME         pass entry name to callback.
//                   cIFS_READDIR_CB_DIRENT       pass dirent structure to callback.
//                   cIFS_READDIR_SUBDIRECTORY    process sub-directories.
//                   cIFS_READDIR_PRE_ORDER       first callback, then subdirectory.
//                   cIFS_READDIR_POST_ORDER      first subdirectory, then callback.
//                   cIFS_READDIR_RESOLVE_SYMLNK  resolve symbolic links.
//   i_pUserData   - Pointer to user data.
//   o_msg         - Error message.
//
//  Returns:
//   rc            - Returns the number of entries found on success, else -1.
// ------------------------------------------------------------------------
//  Callback:      ifsDirectory_read_Path      (cIFS_READDIR_CB_NAME)
//
//  Parameters:
//   i_level       - Nesting level. The first directory is level 1.
//   i_directory   - Path of the current directory.
//   i_entry       - Name of the current directory entry.
//   i_type        - Type of the current directory entry.
//   o_msg         - Error message.
//
//  Returns:
//   doContinue    - Returns cIFS_CONTINUE on succes, else cIFS_CANCEL;
//
// ------------------------------------------------------------------------
//  Callback:      ifsDirectory_read_Dirent    (cIFS_READDIR_CB_DIRENT)
//
//  Parameters:
//   i_level       - Nesting level. The first directory is level 1.
//   i_directory   - Path of the current directory.
//   i_dirent      - Structure dirent_t of the current directory entry.
//   i_type        - Type of the current directory entry.
//   o_msg         - Error message.
//
//  Returns:
//   doContinue    - Returns cIFS_CONTINUE on succes, else cIFS_CANCEL;
//
// ------------------------------------------------------------------------
//  Known directory entry types:
//   cIFS_DIRENT_TYPE_FILE          - File.
//   cIFS_DIRENT_TYPE_DOCUMENT      - Document, member of folder in QDLS.
//   cIFS_DIRENT_TYPE_DIRECTORY     - Directory.
//   cIFS_DIRENT_TYPE_FOLDER        - Folder, contained in QDLS.
//   cIFS_DIRENT_TYPE_SYMBOLIC_LINK - Symbolic link.
//
//=========================================================================
DCL-PROC ifsDirectory_read EXPORT;
  //
  DCL-PI *N INT(10);
    i_path      CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    i_pCallback POINTER(*PROC) CONST;
    i_options   INT(10) CONST OPTIONS(*NOPASS: *OMIT);
    i_pUserData POINTER CONST OPTIONS(*NOPASS: *OMIT);
    o_msg       LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;
  //
  //  Return value
  DCL-S numEntries INT(10) INZ;
  //
  //  Parameter positions
  DCL-C p_options 3;
  DCL-C p_pUserData 4;
  DCL-C p_msg 5;
  //
  //  Fields for optional parameters
  DCL-S pUserData LIKE(i_pUserData) INZ;
  DCL-S options LIKE(i_options) INZ;
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  Helper fields
  DCL-S doAllEntries IND INZ(cFalse);
  DCL-S isPreOrder IND INZ(cFalse);
  DCL-S isPostOrder IND INZ(cFalse);
  DCL-S isUserError IND INZ(cFalse);
  DCL-S doResolveSymLinks IND INZ(cFalse);
  DCL-S path LIKE(i_path) INZ;
  DCL-S directory LIKE(i_path) INZ;
  DCL-S pattern LIKE(i_path) INZ;
  DCL-S entry LIKE(i_path) INZ;
  DCL-S numSubEntries LIKE(numEntries) INZ;
  DCL-S pDIR POINTER INZ;
  DCL-S level INT(10) INZ STATIC;
  DCL-DS dirEnt LIKEDS(dirent_t) BASED(pDirEnt);
  DCL-DS st_stat LIKEDS(st_stat_t) INZ;
  //
  //  Callback Procedures
  //
  DCL-PR ifsDirectory_read_Path IND EXTPROC(i_pCallback);
    i_level     INT(10) CONST;
    i_directory CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    i_file      CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    i_type      CONST LIKE(ifs_type_t);
    i_pUserData POINTER CONST;
    o_msg       LIKE(msg_t);
  END-PR;
  //
  DCL-PR ifsDirectory_read_Dirent IND EXTPROC(i_pCallback);
    i_level     INT(10) CONST;
    i_directory CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    i_dirent    CONST LIKEDS(dirent_t);
    i_type      CONST LIKE(ifs_type_t);
    i_pUserData POINTER CONST;
    o_msg       LIKE(msg_t);
  END-PR;
  //
/COPY QIFS2,IFS1017  Entry has not been read from directory
/COPY QIFS2,IFS1018  Attributes of object '&1' not retrieved
/COPY QIFS2,IFS1019  Directory '&1' not opened.
/COPY QIFS2,IFS1020  Directory '&1' not closed.
/COPY QIFS2,IFS1050  Attributes of symbolic link '&1' not ..
  // ---------------------------------------------------------

  //Process optional parameters ...
  //... i_options
  if (%parms() >= p_options and %addr(i_options) <> *NULL);
    options = i_options;
  else;
    options = cIFS_READDIR_DFT;
  endif;

  //... i_pUserData
  if (%parms() >= p_pUserData and %addr(i_pUserData) <> *NULL);
    pUserData = i_pUserData;
  else;
    pUserData = *NULL;
  endif;

  //Clear error message
  msg = AppMsg_new(cMsg_ID_OK);

  //Check and complete default settings
  //     cIFS_READDIR_FILE
  //     cIFS_READDIR_DIRECTORY
  //     cIFS_READDIR_CB_NAME
  //     cIFS_READDIR_PRE_ORDER
  if (not f_isBitOn(cIFS_READDIR_FILE: options) and
      not f_isBitOn(cIFS_READDIR_DIRECTORY: options));
    options = %bitor(cIFS_READDIR_FILE
                     : cIFS_READDIR_DIRECTORY
                     : options);
  endif;

  if (not f_isBitOn(cIFS_READDIR_CB_NAME: options) and
      not f_isBitOn(cIFS_READDIR_CB_DIRENT: options));
    options = %bitor(cIFS_READDIR_CB_NAME: options);
  endif;

  isPreOrder  = f_isBitOn(cIFS_READDIR_PRE_ORDER: options);
  isPostOrder = f_isBitOn(cIFS_READDIR_POST_ORDER: options);

  if (not isPreOrder and not isPostOrder);
    options = %bitor(cIFS_READDIR_PRE_ORDER: options);
    isPreOrder = cTrue;
  endif;

  doResolveSymLinks = f_isBitOn(cIFS_READDIR_RESOLVE_SYMLNK: options);

  //Increase call level
  level = level + 1;

  //Fix path (slashes)
  path = ifsPath_fixSyntax(i_path);

  //Add "*.*" if path does not contain entry mask
  if (f_endsWith(cSLASH: path));
    path = path + '*.*';
  endif;

  directory = ifsPath_getDirectory(path);
  pattern   = ifsPath_getName(path);

  doAllEntries = f_isBitOn(cIFS_READDIR_ALL: options);

  //Open directory
  pDIR = opendir(directory);
  if (pDIR = *NULL);
    //... create error message
    clear IFS1019;
    IFS10191 = %trimR(directory);
    IFS10192 = f_errno();
    IFS10193 = f_strerror(f_errno());
    msg = AppMsg_newEscape('IFS1019': IFS1019);
  else;

    //Spin through directory entries
    pDirEnt = *NULL;
    dou (pDirEnt = *NULL);

      //Process directory entry
      if (pDirEnt <> *NULL);

        //Get entry name
        entry = %subst(dirent.d_name: 1: dirent.d_namelen);

        //Ignore '.' and '..' directory entries
        if ((entry <> '.' and entry <> '..') or doAllEntries);

          //Get file information
          if (lstat(directory + entry: %addr(st_stat)) = RC_ERROR);
            if   f_errno() = ENOENT_C;   //No such path or directory
              entry = '';
            else;
              clear IFS1018;
              IFS10181 = directory + entry;
              IFS10182 = f_errno();
              IFS10183 = f_strerror(f_errno());
              msg = AppMsg_newEscape('IFS1018': IFS1018);
              leave;
            endif;
          endif;

          //Resolve symbolic links
          if (entry <> '' and
              STAT_isSymbolicLink(st_stat) and doResolveSymLinks);
            if (stat(directory + entry: %addr(st_stat)) = RC_ERROR);
              if   f_errno() = ENOENT_C;   //No such path or directory
                entry = '';
              else;
                clear IFS1050;
                IFS10501 = directory + entry;
                IFS10502 = f_errno();
                IFS10503 = f_strerror(f_errno());
                msg = AppMsg_newEscape('IFS1050': IFS1050);
                leave;
              endif;
            endif;
          endif;

          //Process sub-directory
          //(post-order: first subdirectory, then calback
          if (entry <> '' and isPostOrder);
            exsr processSubDirectory;
            if (numSubEntries = RC_ERROR);
              leave;
            endif;
          endif;

          //If the entry matches the pattern ...
          if (entry <> '' and
              i_pCallback <> *NULL and
              File_matchesPattern(entry: pattern));

            //... and the filter criteria, ...
            if (doAllEntries or
                (STAT_isFile(st_stat) and
                 f_isBitOn(cIFS_READDIR_FILE: options)) or
                (STAT_isDirectory(st_stat ) and
                 f_isBitOn(cIFS_READDIR_DIRECTORY: options)));

              //... then call the requested callback procedure:
              select;
              when (f_isBitOn(cIFS_READDIR_CB_NAME: options));
                if (not ifsDirectory_read_Path(
                              level: directory: entry:
                              %str(%addr(st_stat.objType)):
                              pUserData: msg));
                  isUserError = cTrue;
                  leave;
                endif;

                numEntries = numEntries + 1;

              when (f_isBitOn(cIFS_READDIR_CB_DIRENT: options));
                if (not ifsDirectory_read_Dirent(
                              level: directory: dirent:
                              %str(%addr(st_stat.objType)):
                              pUserData: msg));
                  isUserError = cTrue;
                  leave;
                endif;

                numEntries = numEntries + 1;

              endsl;

            endif;
          endif;

          //Process sub-directory
          //(pre-order: first callback, then subdirectory
          if (entry <> '' and isPreOrder);
            exsr processSubDirectory;
            if (numSubEntries = RC_ERROR);
              leave;
            endif;
          endif;

        endif;
      endif;

      //Read next entry
      f_clrErrno();
      pDirEnt = readdir(pDIR);
      //If we got an error ...
      if (pDirEnt = *NULL) and (f_errno <> 0);
        //... then create error message
        clear IFS1017;
        IFS10171 = directory;
        IFS10172 = f_errno();
        IFS10173 = f_strerror(f_errno());
        msg = AppMsg_newEscape('IFS1017': IFS1017);
        leave;
      endif;
    enddo;

    //Close directory
    if (closedir(pDIR) = RC_ERROR);
      if (msg.ID = cMsg_ID_OK);
        clear IFS1020;
        IFS10201 = directory;
        IFS10202 = f_errno();
        IFS10203 = f_strerror(f_errno());
        msg = AppMsg_newEscape('IFS1020': IFS1020);
      endif;
    endif;
  endif;

  //Set return value
  if (msg.ID <> cMsg_ID_OK);
    numEntries = cIFS_ERROR;
  endif;

  //Ensure that message has been correctly set
  if (not isUserError);
    p_assert(msg.ID = cMsg_ID_OK or msg.type = cMsg_Escape);
  endif;

  //If the message parameter was passed ...
  if (%parms() >= p_msg);
    //... and not omitted
    if (%addr(o_msg) <> *NULL);
      //Return back message
      o_msg = msg;
    endif;
  else;
    //... else send message
    if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
    endif;
  endif;

  //Decrease call level
  level = level - 1;

  return numEntries;

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //   Process subdirectory
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  begsr processSubDirectory;

    if (STAT_isDirectory(st_stat) and
        f_isBitOn(cIFS_READDIR_SUBDIRECTORY: options));
      if (entry <> pattern);
        path =ifsPath_fixSyntax(directory + entry + cSLASH + pattern);
      else;
        path =ifsPath_fixSyntax(directory + entry + cSLASH);
      endif;
      numSubEntries = ifsDirectory_read(path
                                        : i_pCallback
                                        : options
                                        : pUserData
                                        : msg);
      if (numSubEntries = RC_ERROR);
        leavesr;
      endif;

      numEntries = numEntries + numSubEntries;
    endif;

  endsr;

//
END-PROC;
//
//=========================================================================
//  Returns cTrue if a given directory is empty, else cFalse.
//=========================================================================
//  Parameters:
//   i_dir         - The name of a directory.
//   o_msg         - Error message.
//
//  Returns:
//   rc            - Returns cTrue if the directory is empty, else cFalse.
//=========================================================================
DCL-PROC ifsDirectory_isEmpty EXPORT;
  //
  DCL-PI *N IND;
    i_directory CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    o_msg       LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;
  //
  //  Return value
  DCL-S isEmpty IND INZ(cFalse);
  //
  //  Parameter positions
  DCL-C p_msg 2;
  //
  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  Helper fields
  DCL-S isDirOpen IND INZ(cFalse);
  DCL-S directory LIKE(i_directory) INZ;
  DCL-S pDIR POINTER INZ;
  DCL-S entry CHAR(4) INZ;
  DCL-DS dirEnt LIKEDS(dirent_t) BASED(pDirEnt);
  //
/COPY QIFS2,IFS1017  Entry has not been read from direct
/COPY QIFS2,IFS1019  Directory '&1' not opened.
/COPY QIFS2,IFS1020  Directory '&1' not closed.
  // ---------------------------------------------------------

  //Clear error message
  msg = AppMsg_new(cMsg_ID_OK);

  dou '1';

    //Fix path (slashes)
    directory = ifsDirectory_fixSyntax(i_directory);

    //Check, whether the specified directory exists or not
    if (not ifsDirectory_exist(directory: msg));
      leave;
    endif;

    //Open directory
    pDIR = opendir(directory);
    if (pDIR = *NULL);
      //... create error message
      clear IFS1019;
      IFS10191 = directory;
      IFS10192 = f_errno();
      IFS10193 = f_strerror(f_errno());
      msg = AppMsg_newEscape('IFS1019': IFS1019);
      leave;
    endif;

    isDirOpen = cTrue;

    //Spin through directory entries
    pDirEnt = *NULL;
    dou (pDirEnt = *NULL);
      //Process directory entry
      if (pDirEnt <> *NULL);
        //Get entry name
        entry = %subst(dirent.d_name: 1: dirent.d_namelen);
        //Ignore '.' and '..' directory entries
        if ((entry <> '.' and entry <> '..'));
          leave;   //Directory is not empty!
        endif;
      endif;

      //Read next entry
      f_clrErrno();
      pDirEnt = readdir(pDIR);
      if (pDirEnt = *NULL);   //End of list
        if (f_errno <> 0);
          clear IFS1017;
          IFS10171 = directory;
          IFS10172 = f_errno();
          IFS10173 = f_strerror(f_errno());
          msg = AppMsg_newEscape('IFS1017': IFS1017);
          leave;
        else;
          isEmpty = cTrue;   //Directory is empty.
        endif;
      endif;
    enddo;

  enddo;

  //Close directory
  if (isDirOpen);
    if (closedir(pDIR) = RC_OK);
      isDirOpen = cFalse;
    else;
      clear IFS1020;
      IFS10201 = directory;
      IFS10202 = f_errno();
      IFS10203 = f_strerror(f_errno());
      msg = AppMsg_newEscape('IFS1020': IFS1020);
    endif;
  endif;

  //Ensure that message has been correctly set
  p_assert(msg.ID = cMsg_ID_OK or msg.type = cMsg_Escape);

  //If the message parameter was passed ...
  if (%parms() >= p_msg);
    //... and not omitted
    if (%addr(o_msg) <> *NULL);
      //Return back message
      o_msg = msg;
    endif;
  else;
    //... else send message
    if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
    endif;
  endif;

  return isEmpty;

//
END-PROC;
//
//=========================================================================
//  Returns the current working directory.
//=========================================================================
//  Parameters:
//   o_msg         - Error message.
//
//  Returns:
//   directory     - Current directory on success, else empty string.
//=========================================================================
DCL-PROC ifsDirectory_getCurrent EXPORT;
  //
  DCL-PI *N LIKE(ifs_path_t);
    o_msg LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;
  //
  //  Return value
  DCL-S directory LIKE(ifs_path_t) INZ;
  //
  //  Parameter positions
  DCL-C p_msg 1;
  //
  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  Helper fields
  DCL-S tmpDirectory CHAR(1024) INZ;
  //
/COPY QIFS2,IFS1029  Failed to get the current working ...
  // ---------------------------------------------------------

  //Clear error message
  msg = AppMsg_new(cMsg_ID_OK);

  dou '1';

    //Get current working directory
    if (getcwd(tmpDirectory: %size(tmpDirectory)) = *NULL);
      //... create error message on error
      clear IFS1029;
      IFS10291 = f_errno();
      IFS10292 = f_strerror(f_errno());
      msg = AppMsg_newEscape('IFS1029': IFS1029);
      leave;
    endif;

    directory = ifsDirectory_fixSyntax(%str(%addr(tmpDirectory)));
  enddo;

  //Ensure that message has been correctly set
  p_assert(msg.ID = cMsg_ID_OK or msg.type = cMsg_Escape);

  //If the message parameter was passed ...
  if (%parms() >= p_msg);
    //... and not omitted
    if (%addr(o_msg) <> *NULL);
      //Return back message
      o_msg = msg;
    endif;
  else;
    //... else send message
    if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
    endif;
  endif;

  return directory;

//
END-PROC;
//
//=========================================================================
//  Changes the current working directory.
//=========================================================================
//  Parameters:
//   i_directory   - Directory that should become the current directory.
//   o_msg         - Error message.
//
//  Returns:
//   rc            - Returns cIFS_OK on success, else cIFS_ERROR.
//=========================================================================
DCL-PROC ifsDirectory_setCurrent EXPORT;
  //
  DCL-PI *N INT(10);
    i_directory CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    o_msg       LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;
  //
  //  Return value
  DCL-S rc INT(10) INZ(RC_ERROR);
  //
  //  Parameter positions
  DCL-C p_msg 2;
  //
  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  Helper fields
  DCL-DS tmpDir LIKEDS(Qlg_Path_Name_t) INZ;
  //
  //  Helper fields
  //
/COPY QIFS2,IFS1030  Failed to change the current working ..
  // ---------------------------------------------------------

  //Clear error message
  msg = AppMsg_new(cMsg_ID_OK);

  dou '1';

    //Prepare path name
    tmpDir = QLG_PATH_new(ifsDirectory_fixSyntax(i_directory));

    //Change current working directory
    if (QlgChdir(tmpDir) <> 0);
      //... create error message on error
      clear IFS1030;
      IFS10301 = i_directory;
      IFS10302 = f_errno();
      IFS10303 = f_strerror(f_errno());
      msg = AppMsg_newEscape('IFS1030': IFS1030);
      leave;
    endif;

    rc = RC_OK;
  enddo;

  //Ensure that message has been correctly set
  p_assert(msg.ID = cMsg_ID_OK or msg.type = cMsg_Escape);

  //If the message parameter was passed ...
  if (%parms() >= p_msg);
    //... and not omitted
    if (%addr(o_msg) <> *NULL);
      //Return back message
      o_msg = msg;
    endif;
  else;
    //... else send message
    if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
    endif;
  endif;

  return rc;

//
END-PROC;
//
//=========================================================================
//  Returns the creation timestamp of a given directory.
//=========================================================================
//  Parameters:
//   i_directory   - The name of a given directory.
//   o_msg         - Error message.
//
//  Returns:
//   crtTime       - Timestamp the directory was created on success, else
//                   *LOVAL.
//=========================================================================
DCL-PROC ifsDirectory_getCreationTime EXPORT;
  //
  DCL-PI *N TIMESTAMP;
    i_directory CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    o_msg       LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;
  //
  //  Return value
  DCL-S crtTime TIMESTAMP INZ(*LOVAL);
  //
  //  Parameter positions
  DCL-C p_msg 2;
  //
  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  Local fields
  DCL-S tmpRC INT(10) INZ;
  DCL-S tmpCrtTime TIMESTAMP INZ;
  //
/COPY QIFS2,IFS1048  Failed to retrieve the timestamp the ..
  // ---------------------------------------------------------

  //Retrieve file creation time ...
  tmpRC = FileAttr_getTime(ifsDirectory_fixSyntax(i_directory)
                           : QP0L_ATTR_CREATE_TIME: tmpCrtTime);
  if (tmpRC = RC_ERROR);
    clear IFS1048;
    IFS10481 = i_directory;
    IFS10482 = f_errno();
    IFS10483 = f_strerror(f_errno());
    msg = AppMsg_newEscape('IFS1048': IFS1048);
    crtTime = *LOVAL;
  else;
    msg = AppMsg_new(cMsg_ID_OK);
    crtTime = tmpCrtTime;
  endif;

  //Ensure that message has been correctly set
  p_assert(msg.ID = cMsg_ID_OK or msg.type = cMsg_Escape);

  //If the message parameter was passed ...
  if (%parms() >= p_msg);
    //... and not omitted
    if (%addr(o_msg) <> *NULL);
      //Return back message
      o_msg = msg;
    endif;
  else;
    //... else send message
    if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
    endif;
  endif;

  return    crtTime;

//
END-PROC;
//
//=========================================================================
//  Returns the timestamp the content of the directory was last changed.
//=========================================================================
//  Parameters:
//   i_directory   - The name of a given directory.
//   o_msg         - Error message.
//
//  Returns:
//   chgTime       - Timestamp the content of the directory was last
//                   changed on success, else *LOVAL;
//=========================================================================
DCL-PROC ifsDirectory_getContentChangeTime EXPORT;
  //
  DCL-PI *N TIMESTAMP;
    i_directory CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    o_msg       LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;
  //
  //  Return value
  DCL-S chgTime TIMESTAMP INZ(*LOVAL);
  //
  //  Parameter positions
  DCL-C p_msg 2;
  //
  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  Local fields
  DCL-S tmpRC INT(10) INZ;
  DCL-S tmpChgTime TIMESTAMP INZ;
  //
/COPY QIFS2,IFS1049  Failed to retrieve the timestamp the ..
  // ---------------------------------------------------------

  //Retrieve the time the file data was last changed ...
  tmpRC = FileAttr_getTime(ifsDirectory_fixSyntax(i_directory)
                           : QP0L_ATTR_MODIFY_TIME: tmpChgTime);
  if (tmpRC = RC_ERROR);
    clear IFS1049;
    IFS10491 = i_directory;
    IFS10492 = f_errno();
    IFS10493 = f_strerror(f_errno());
    msg = AppMsg_newEscape('IFS1049': IFS1049);
    chgTime = *LOVAL;
  else;
    msg = AppMsg_new(cMsg_ID_OK);
    chgTime = tmpChgTime;
  endif;

  //Ensure that message has been correctly set
  p_assert(msg.ID = cMsg_ID_OK or msg.type = cMsg_Escape);

  //If the message parameter was passed ...
  if (%parms() >= p_msg);
    //... and not omitted
    if (%addr(o_msg) <> *NULL);
      //Return back message
      o_msg = msg;
    endif;
  else;
    //... else send message
    if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
    endif;
  endif;

  return chgTime;

//
END-PROC;
//
//=========================================================================
//  Fixes the syntax of a given directory name.
//  (Hint:   path = directory + file)
//=========================================================================
//  Parameters:
//   i_directory   - A given directory name.
//
//  Returns:
//   directory     - The fixed directory name.
//=========================================================================
DCL-PROC ifsDirectory_fixSyntax EXPORT;
  //
  DCL-PI *N LIKE(ifs_path_t);
    i_directory CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  END-PI;
  //
  //  Return value
  DCL-S directory LIKE(ifs_path_t) INZ;
  // ---------------------------------------------------------

  //If no directory was specified, ...
  if (i_directory = '');
    //... then return to caller
    return i_directory;
  endif;

  //Translate backslashes ('\') to slashes ('/')
  directory = %xlate(cBACKSLASH: cSLASH: i_directory);

  //Append missing slash
  if (not f_endsWith(cSLASH: directory));
    directory = directory + cSLASH;
  endif;

  return directory;

//
END-PROC;
//
//=========================================================================
//  *** private ***
//  Deletes all entries of a given directory and its subdirectories.
//=========================================================================
DCL-PROC clearDirectory;
  //
  DCL-PI *N IND;
    i_level     INT(10) CONST;
    i_directory CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    i_entry     CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    i_type      CONST LIKE(ifs_type_t);
    i_pUsrDta   POINTER CONST;
    o_msg       LIKE(msg_t);
  END-PI;
  //
  //  Helper fields
  DCL-S tmpRC INT(10) INZ;
  DCL-S tmpPath LIKE(ifs_path_t) INZ;
  DCL-DS tmpMsg LIKEDS(msg_t) INZ;
  //
  //  User data
  DCL-DS usrDta LIKEDS(clrDirUsrDta_t) BASED(i_pUsrDta);
  // ---------------------------------------------------------

  tmpPath = i_directory + i_entry;

  select;
  when (i_type = cIFS_DIRENT_TYPE_DIRECTORY or
        i_type = cIFS_DIRENT_TYPE_FOLDER);
    tmpRC = ifsDirectory_remove(tmpPath: usrDta.options: tmpMsg);
    if (tmpRC = cIFS_ERROR);
      o_msg = tmpMsg;
      return cFalse;
    else;
      usrDta.numE = usrDta.numE + tmpRC;
    endif;

  when (i_type = cIFS_DIRENT_TYPE_FILE or
        i_type = cIFS_DIRENT_TYPE_DOCUMENT);
    if (ifsFile_delete(tmpPath: tmpMsg) = cIFS_ERROR);
      o_msg = tmpMsg;
      return cFalse;
    else;
      usrDta.numE = usrDta.numE + 1;
    endif;

  endsl;

  o_msg = AppMsg_new(cMsg_ID_OK);

  return cTrue;

//
END-PROC;
//
