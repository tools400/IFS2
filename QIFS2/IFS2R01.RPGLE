**FREE
//=====================================================================*
//  IFS2R01    - Tools/400: Stream File and Directory - File           *
//=====================================================================*
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
CTL-OPT COPYRIGHT('V1.9 - 29.01.2009 - mailto:thomas.raddatz@tools400.de      +
  PKGMGR(version=1.9; date=29.01.2009; +
  domain=de.tools400.ifs2.)');
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
/COPY QBASICS1,PBASICS1  Tools/400 Runtime Library
/COPY QIFS2,PIFS2R04  App.Msg
/COPY QIFS2,PIFS2R05  Application
/COPY QIFS2,PIFS2R99  Miscellaneous
//
// ------------------------------------
//  Private prototypes
// ------------------------------------
//
//  Checks the size of a given handle buffer and reallocates memory
//  if the buffer is too small.
DCL-PR checkHandleBufferSizeAndReallocate POINTER EXTPROC('checkHandleBufferSizeAndReallocate');
  io_buffer LIKEDS(buffer_t);
  i_newSize INT(10) CONST;
END-PR;
//
//  Free a given temporary buffer.
DCL-PR freeHandleBuffer EXTPROC('freeHandleBuffer');
  io_buffer LIKEDS(buffer_t);
END-PR;
//
//  Produces a unique file ID.
DCL-PR produceUniqueFileID LIKEDS(ifs_uniqueFileID_t) EXTPROC('produceUniqueFileID');
  i_st_stat CONST LIKEDS(st_stat_t);
END-PR;
//
//  Produces a file ID as shown at the WRKLNK 'Display Attributes' screen.
DCL-PR produceFileID LIKE(ifs_fileID_t) EXTPROC('produceFileID');
  i_st_stat CONST LIKEDS(st_stat_t);
END-PR;
//
//  Append the data of a given file to a target file.
DCL-PR copyFileCreateOrAppend IND EXTPROC('copyFileCreateOrAppend');
  i_fromPath CONST LIKE(ifs_path_t);
  i_toPath   CONST LIKE(ifs_path_t);
  i_toCcsid  CONST LIKE(ifs_ccsid_t);
  o_msg      LIKE(msg_t);
END-PR;
//
//  Compares the given buffers with each other.
DCL-PR compareBuffers INT(10) EXTPROC('compareBuffers');
  i_pBuffer1 POINTER CONST;
  i_pBuffer2 POINTER CONST;
  i_size     INT(10) CONST;
END-PR;
//
// ------------------------------------
//  Type definitions
// ------------------------------------
/COPY QIFS2,TYPES 
//
DCL-DS handle_t QUALIFIED BASED(pDummy);
  hFileUnix      INT(10);
  useWriteBuffer IND;
  reserved_1     CHAR(5);
  writeBuffer    LIKEDS(buffer_t);
  path           LIKE(ifs_path_t);
END-DS;
//
DCL-DS buffer_t QUALIFIED BASED(pDummy);
  pData      POINTER;
  size       INT(10);
  reserved_1 CHAR(12);
END-DS;
//
// ------------------------------------
//  Global constants
// ------------------------------------
//
DCL-C cBUFFER_SIZE 8196;
//
// ------------------------------------
//  Global fields
// ------------------------------------
//
//=========================================================================
//  Returns cTrue if the specified file exists, else cFalse.
//=========================================================================
//  Parameters:
//   i_path        - The name of a stream file.
//
//  Returns:
//   doesExist     - Returns cTrue if the file exists, else cFalse.
//=========================================================================
DCL-PROC ifsFile_exist EXPORT;
  //
  DCL-PI *N IND;
    i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;
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
/COPY QIFS2,IFS1036  Failed to retrieve file information.
  // ---------------------------------------------------------

  f_clrErrno();

  //If the object could not be found, ...
  if (stat(ifsPath_fixSyntax(i_path): %addr(st_stat)) = RC_ERROR);
    //... check error code to ensure that it is 3025 "no such file or directory"
    if (f_errno() <> ENOENT_C);
      clear IFS1036;
      IFS10361 = i_path;
      IFS10362 = f_errno();
      IFS10363 = f_strerror(f_errno());
      Application_killWithMsg(AppMsg_newEscape('IFS1036': IFS1036));
    endif;
    return cFalse;
  endif;

  //Ensure that the object is a file and not a directory.
  if (not STAT_isFile(st_stat));
    return cFalse;
  endif;

  return cTrue;

//
END-PROC;
//
//=========================================================================
//  Opens a given stream file.
//=========================================================================
//  Parameters:
//   i_path        - A given IFS path name.
//   i_opnFlags    - O_CREAT        If the file being opened does not exist,
//                                  create it.
//                   O_EXCL         Send error message if file exists and
//                                  O_CREAT was specified.
//                   O_TRUNC        Truncate the file to zero length.
//                   O_APPEND       Position the file offset at the end of
//                                  the file before each write operation.
//                   O_CODEPAGE     The call to open has a codepage argument.
//                                  This flag cannot be specified with the
//                                  O_CCSID flag.
//                   O_TEXTDATA     The data is processed as text.
//                   O_INHERITMODE  Create the file with the same data
//                                  authorities as the parent file.
//                   O_CCSID        Text conversions between any two CCSIDs
//                                  supported by the iconv() API can be performed.
//                                  This flag cannot be specified with the
//                                  O_CODEPAGE flag.
//
//                   O_SHARE_RDONLY Share with readers only.
//                   O_SHARE_WRONLY Share with writers only.
//                   O_SHARE_RDWR   Share with readers and writers.
//                   O_SHARE_NONE   Share with neither readers nor writers.
//
//                   O_RDONLY       Open for reading only.
//                   O_WRONLY       Open for writing only.
//                   O_RDWR         Open for both reading and writing.
//
//   i_codePage    - When the O_CODEPAGE flag is specified, i_codepage
//                   must contain the codepage of the new file.
//                   When the O_CCSID flag is specified, i_codepage
//                   must contain the CCSID of the new file.
//   i_auth        - S_IRUSR        Owner has read authority.
//                   S_IWUSR        Owner has write authority.
//                   S_IXUSR        Owner has execute/search authority.
//                   S_IRWXU        Owner has all authorities.
//
//                   S_IRGRP        Group has read authority.
//                   S_IWGRP        Group has write authority.
//                   S_IXGRP        Group has execute/search authority.
//                   S_IRWXG        Group has all authorities.
//
//                   S_IROTH        Public has read authority.
//                   S_IWOTH        Public has write authority.
//                   S_IXOTH        Public has execute/search authority.
//                   S_IRWXO        Public has all authorities.
//   o_msg         - Error message.
//
//  Returns:
//   hFile         - The handle of the open file.
//=========================================================================
DCL-PROC ifsFile_open EXPORT;
  //
  DCL-PI *N LIKE(ifs_hFile_t);
    i_path     CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    i_opnFlags INT(10) CONST;
    i_codePage INT(10) CONST OPTIONS(*NOPASS: *OMIT);
    i_auth     INT(10) CONST OPTIONS(*NOPASS: *OMIT);
    o_msg      LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;
  //
  //  Return value
  DCL-S hFile LIKE(ifs_hFile_t) INZ;
  //
  //  Parameter positions
  DCL-C p_codePage 3;
  DCL-C p_auth 4;
  DCL-C p_msg 5;
  //
  //  Fields for optional parameters
  DCL-S codePage LIKE(i_codePage) INZ;
  DCL-S auth LIKE(i_auth) INZ;
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  Helper fields
  DCL-S path LIKE(i_path) INZ;
  DCL-S opnFlags LIKE(i_opnFlags) INZ;
  DCL-S doesExist IND INZ(cFalse);
  DCL-S rc INT(10) INZ;
  DCL-S hFileUnix INT(10) INZ;
  //
  //  File handle
  DCL-DS handle LIKEDS(handle_t) BASED(pHandle);
  //
/COPY QIFS2,IFS1000  Failed to open file '&1'.
  // ---------------------------------------------------------

  //Process optional parameters ...
  //... i_codePage
  if (%parms() >= p_codePage and %addr(i_codePage) <> *NULL);
    codePage = i_codePage;
  else;
    codePage = cDFT_ASC_CODEPAGE;
  endif;

  //... i_auth
  if (%parms() >= p_auth and %addr(i_auth) <> *NULL);
    auth = i_auth;
  else;
    auth = S_IRWXU + S_IRWXG + S_IRWXO;  //*PUBLIC = *ALL
  endif;

  //Initialize return value
  hFile = HANDLE_null();

  //Clear error message
  msg = AppMsg_new(cMsg_ID_OK);

  //Fix path (slashes)
  path = ifsPath_fixSyntax(i_path);

  //Check file existance
  doesExist = ifsFile_exist(path);

  //Set open flags
  opnFlags = i_opnFlags;

  //If O_CODEPAGE and O_CCSID are not specified ...
  if (not f_isBitOn(O_CODEPAGE: opnFlags) and
      not f_isBitOn(O_CCSID   : opnFlags));
    //... and the file does not exists
    if (not doesExist);
      //... then set O_CODEPAGE
      opnFlags = opnFlags + O_CODEPAGE;
    endif;
  else;
    //... else if the file already exists
    if (doesExist);
      //... then remove O_CODEPAGE or O_CCSID
      select;
      when f_isBitOn(O_CODEPAGE: opnFlags);
        opnFlags = opnFlags - O_CODEPAGE;
      when f_isBitOn(O_CCSID   : opnFlags);
        opnFlags = opnFlags - O_CCSID;
      endsl;
    endif;
  endif;

  //Open the file
  hFileUnix = open(path: opnFlags: auth: codePage);

  //If the file was just created ...
  if (hFileUnix <> RC_ERROR and not doesExist);
    //... then re-open the file to let the operating system
    //    do codepage conversion.
    if (close(hFileUnix) = RC_ERROR);
      hFileUnix = RC_ERROR;
    else;
      //Remove the O_CODEPAGE or O_CCSID flag
      select;
      when f_isBitOn(O_CODEPAGE: opnFlags);
        opnFlags = opnFlags - O_CODEPAGE;
      when f_isBitOn(O_CCSID   : opnFlags);
        opnFlags = opnFlags - O_CCSID;
      endsl;
      //Remove the O_CREAT flag
      if (f_isBitOn(O_CREAT: opnFlags));
        opnFlags = opnFlags - O_CREAT;
      endif;
      //Re-open the file
      hFileUnix = open(path: opnFlags);
    endif;
  endif;

  //In case on an open error ...
  if (hFileUnix = RC_ERROR);
    //... create error message
    clear IFS1000;
    IFS10001 = path;
    IFS10002 = f_errno();
    IFS10003 = f_strerror(f_errno());
    msg = AppMsg_newEscape('IFS1000': IFS1000);
  else;
    //... else produce a file handle
    hFile = HANDLE_new('*IFS2': %size(handle_t));
    pHandle = HANDLE_getPointer(hFile);

    clear handle;
    handle.hFileUnix = hFileUnix;
    handle.path      = path;
    handle.useWriteBuffer = (f_isBitOn(O_SHARE_WRONLY: opnFlags) or
                             f_isBitOn(O_SHARE_RDWR  : opnFlags)) and
                            (f_isBitOn(O_WRONLY: opnFlags) or
                             f_isBitOn(O_RDWR  : opnFlags));

    p_assert(handle.writeBuffer.pData = *NULL and
             handle.writeBuffer.size = 0
             : 'Handle buffer not correctly initialized');

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

  return hFile;

//
END-PROC;
//
//=========================================================================
//  Closes an stream file that has been opened with the
//  ifsFile_open-function.
//=========================================================================
//  Parameters:
//   i_hFile       - The handle of a file as returned by ifsFile_open().
//   o_msg         - Error message.
//
//  Returns:
//   rc            - Returns cIFS_OK on success, else cIFS_ERROR.
//=========================================================================
DCL-PROC ifsFile_close EXPORT;
  //
  DCL-PI *N INT(10);
    io_hFile LIKE(ifs_hFile_t);
    o_msg    LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;
  //
  //  Return value
  DCL-S rc INT(10) INZ(cIFS_ERROR);
  //
  //  Parameter positions
  DCL-C p_msg 2;
  //
  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  Helper fields
  DCL-S tmpRC INT(10) INZ;
  //
  //  File handle
  DCL-DS handle LIKEDS(handle_t) BASED(pHandle);
  //
/COPY QIFS2,IFS1001  Could not close file '&2'.
  // ---------------------------------------------------------

  //Get access to file handle date
  pHandle = HANDLE_getPointer(io_hFile);

  //Close file
  tmpRC = close(handle.hFileUnix);

  //If we got an error
  if (tmpRC = RC_ERROR);
    //... then create error message
    clear IFS1001;
    IFS10011 = handle.path;
    IFS10012 = f_errno();
    IFS10013 = f_strerror(f_errno());
    msg = AppMsg_newEscape('IFS1001': IFS1001);
    rc = cIFS_ERROR;
  else;
    //... else free temporary write buffer
    freeHandleBuffer(handle.writeBuffer);

    //... free file handle
    HANDLE_delete(io_hFile);

    msg = AppMsg_new(cMSG_ID_OK);
    rc = cIFS_OK;
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

  return rc;

//
END-PROC;
//
//=========================================================================
//  Deletes a given stream file.
//=========================================================================
//  Parameters:
//   i_path        - The path name of the stream file to delete.
//   o_msg         - Error message.
//
//  Returns:
//   rc            - Returns cIFS_OK on success, else cIFS_ERROR.
//=========================================================================
DCL-PROC ifsFile_delete EXPORT;
  //
  DCL-PI *N INT(10);
    i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;
  //
  //  Return value
  DCL-S rc INT(10) INZ;
  //
  //  Parameter positions
  DCL-C p_msg 2;
  //
  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  Helper fields
  DCL-S tmpRC INT(10) INZ;
  //
/COPY QIFS2,IFS1005  Failed to delete file '&1'.
  // ---------------------------------------------------------

  //Delete IFS file
  tmpRC = unlink(ifsPath_fixSyntax(i_path));

  //If we got an error, ...
  if (tmpRC = RC_ERROR);
    //... then create error message
    clear IFS1005;
    IFS10051 = i_path;
    IFS10052 = f_errno();
    IFS10053 = f_strerror(f_errno());
    msg = AppMsg_newEscape('IFS1005': IFS1005);
    rc = cIFS_ERROR;
  else;
    //... else create OK message
    msg = AppMsg_new(cMSG_ID_OK);
    rc = cIFS_OK;
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

  return rc;

//
END-PROC;
//
//=========================================================================
//  Moves a given stream file to a new location.
//=========================================================================
//  Parameters:
//   i_fromPath    - The path name of a given stream file.
//   i_toDirectory - The name of the target directory.
//   i_options     - Options:
//                   cIFS_MOVE_FILE_DFT       Default settings.
//                   cIFS_MOVE_FILE_REPLACE   Replace existing target file.
//                   cIFS_MOVE_FILE_ALLOW_RENAME       Move and rename file.
//                   cIFS_MOVE_FILE_CREATE_DIRECTORY   Create TO directory
//                                                     if it does not exist.
//   o_msg         - Error message.
//
//  Returns:
//   rc            - Returns cIFS_OK on success, else cIFS_ERROR.
//=========================================================================
DCL-PROC ifsFile_move EXPORT;
  //
  DCL-PI *N INT(10);
    i_fromPath    CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    i_toDirectory CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    i_options     INT(10) CONST OPTIONS(*NOPASS: *OMIT);
    o_msg         LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;
  //
  //  Return value
  DCL-S rc INT(10) INZ;
  //
  //  Parameter positions
  DCL-C p_options 3;
  DCL-C p_msg 4;
  //
  //  Fields for optional parameters
  DCL-S options LIKE(i_options) INZ;
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  Helper fields
  DCL-S tmpRC INT(10) INZ;
  DCL-S fromPath LIKE(ifs_path_t) INZ;
  DCL-S toPath LIKE(ifs_path_t) INZ;
  DCL-S toFileName LIKE(ifs_path_t) INZ;
  DCL-S toDirectory LIKE(ifs_path_t) INZ;
  //
/COPY QIFS2,IFS1003  Failed to move file '&1' to '&2'.
/COPY QIFS2,IFS1011  Directory '&1' does not exist.
/COPY QIFS2,IFS1012  File '&1' does not exist.
/COPY QIFS2,IFS1047  Directory name '&1' contains invalid ..
  // ---------------------------------------------------------

  //Process optional parameters ...
  //... i_options
  if (%parms() >= p_options and %addr(i_options) <> *NULL);
    options = i_options;
  else;
    options = cIFS_MOVE_FILE_DFT;
  endif;

  msg = AppMsg_new(cMsg_ID_OK);

  dou '1';

    fromPath    = ifsPath_fixSyntax(i_fromPath);

    //If the file does not exist, ...
    if (not ifsFile_exist(fromPath));
      //... then create an error message
      clear IFS1012;
      IFS10121 = fromPath;
      msg = AppMsg_newEscape('IFS1012': IFS1012);
      rc = cIFS_ERROR;
      leave;
    endif;

    //If the target directory name contains a file name, ...
    toFileName = ifsPath_getName(i_toDirectory);

    if (toFileName <> '' and toFileName <> ifsPath_getName(fromPath));
      if (not f_isBitOn(cIFS_MOVE_FILE_ALLOW_RENAME: options));
        //... then create error message
        clear IFS1047;
        IFS10471 = i_toDirectory;
        msg = AppMsg_newEscape('IFS1047': IFS1047);
        rc = cIFS_ERROR;
        leave;
      endif;
    endif;

    if (toFileName = '');
      toDirectory = ifsDirectory_fixSyntax(i_toDirectory);
    else;
      toDirectory = ifsPath_getDirectory(
                          ifsPath_fixSyntax(i_toDirectory));
    endif;

    //If the target directory does not exist, ...
    if (not ifsDirectory_exist(toDirectory));
      if (not f_isBitOn(cIFS_MOVE_FILE_CREATE_DIRECTORY: options));
        //... then create error message
        clear IFS1011;
        IFS10111 = toDirectory;
        msg = AppMsg_newEscape('IFS1011': IFS1011);
        rc = cIFS_ERROR;
        leave;
      endif;

      if (ifsDirectory_create(
             toDirectory: cIFS_MKDIR_SUBDIR: *omit: msg) = cIFS_ERROR);
        rc = cIFS_ERROR;
        leave;
      endif;
    endif;

    //Produce target path
    if (toFilename = '');
      toPath = toDirectory + ifsPath_getName(fromPath);
    else;
      toPath = toDirectory + toFileName;
    endif;

    //Move stream file ...
    if (f_isBitOn(cIFS_MOVE_FILE_REPLACE: options));
      //... replace existing file.
      tmpRC = Qp0lRenameUnlink(fromPath: toPath);
    else;
      //... return ERROR message in case the target file exists
      tmpRC = Qp0lRenameKeep(fromPath: toPath);
    endif;

    //If we got an error
    if (tmpRC = RC_ERROR);
      //... then create message
      clear IFS1003;
      IFS10031 = fromPath;
      IFS10032 = toDirectory;
      IFS10033 = f_errno();
      IFS10034 = f_strerror(f_errno());
      msg = AppMsg_newEscape('IFS1003': IFS1003);
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
//  Renames a given IFS file.
//=========================================================================
//  Parameters:
//   i_fromPath    - Renames a given stream file.
//   i_toFile      - The new file name.
//   o_msg         - Error message.
//
//  Returns:
//   rc            - Returns cIFS_OK on success, else CIFS_ERROR.
//=========================================================================
DCL-PROC ifsFile_rename EXPORT;
  //
  DCL-PI *N INT(10);
    i_fromPath CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    i_toFile   CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    o_msg      LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
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
/COPY QIFS2,IFS1009  Failed to rename file '&1' to '&2'.
/COPY QIFS2,IFS1012  File '&1' does not exist.
/COPY QIFS2,IFS1013  File '&1' already exits.
/COPY QIFS2,IFS1014  File name '&1' contains invalid ...
  // ---------------------------------------------------------

  msg = AppMsg_new(cMsg_ID_OK);

  dou '1';

    //If the file does not exist, ...
    if (not ifsFile_exist(i_fromPath));
      //... then create an error message
      clear IFS1012;
      IFS10121 = i_fromPath;
      msg = AppMsg_newEscape('IFS1012': IFS1012);
      rc = cIFS_ERROR;
      leave;
    endif;

    //If the target file name contains a directory, ...
    if (not ifsPath_isNameOnly(i_toFile));
      //... then create error message
      rc = RC_ERROR;
      clear IFS1014;
      IFS10141 = %trim(i_toFile);
      msg = AppMsg_newEscape('IFS1014': IFS1014);
      rc = cIFS_ERROR;
      leave;
    endif;

    //Compute path of target file
    toPath = ifsPath_fixSyntax(
                ifsPath_getDirectory(i_fromPath) + i_toFile);

    //If the target file does already exist, ...
    if (ifsFile_exist(toPath));
      //... then create error message
      clear IFS1013;
      IFS10131 = toPath;
      msg = AppMsg_newEscape('IFS1013': IFS1013);
      rc = cIFS_ERROR;
      leave;
    endif;

    //Rename stream file
    tmpRC = Qp0lRenameKeep(ifsPath_fixSyntax(i_fromPath): toPath);

    //If we got an error, ...
    if (tmpRC = RC_ERROR);
      //... then create error message
      clear IFS1009;
      IFS10091 = i_fromPath;
      IFS10092 = i_toFile;
      IFS10093 = f_errno();
      IFS10094 = f_strerror(f_errno());
      msg = AppMsg_newEscape('IFS1009': IFS1009);
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
//  Copyies a given file to a directory or another file.
//=========================================================================
//  Parameters:
//   i_fromPath    - The that shall be copied.
//   i_toPath      - The new path name.
//   i_options     - Options:
//                   cIFS_COPY_FILE_DFT       Default settings.
//                   cIFS_COPY_FILE_REPLACE   Replace existing target file.
//                   cIFS_COPY_FILE_APPEND    Append file to target file.
//                   cIFS_COPY_FILE_CREATE_DIRECTORY   Create TO directory
//                                                     if it does not exist.
//   i_ccsid       - CCSID of the target file.
//   o_msg         - Error message.
//
//  Returns:
//   rc            - Returns cIFS_OK on success, else CIFS_ERROR.
//=========================================================================
DCL-PROC ifsFile_copy EXPORT;
  //
  DCL-PI *N INT(10);
    i_fromPath CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    i_toPath   CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    i_options  INT(10) CONST OPTIONS(*NOPASS: *OMIT);
    i_ccsid    CONST LIKE(ifs_ccsid_t) OPTIONS(*NOPASS: *OMIT);
    o_msg      LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;
  //
  //  Return value
  DCL-S rc INT(10) INZ;
  //
  //  Parameter positions
  DCL-C p_options 3;
  DCL-C p_ccsid 4;
  DCL-C p_msg 5;
  //
  //  Fields for optional parameters
  DCL-S options LIKE(i_options) INZ;
  DCL-S ccsid LIKE(i_ccsid) INZ;
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  Helper fields
  DCL-S fileExist IND INZ(cFalse);
  DCL-S appendFile IND INZ(cFalse);
  DCL-S tmpRC INT(10) INZ;
  DCL-S toFile LIKE(ifs_path_t) INZ;
  DCL-S toDirectory LIKE(ifs_path_t) INZ;
  DCL-S toPath LIKE(ifs_path_t) INZ;
  DCL-S cmd VARCHAR(10240) INZ;
  //
  //  stat() result data structure
  DCL-DS st_stat LIKEDS(st_stat_t) INZ;
  //
  //  The CPY command
  DCL-C CMD_CPY 'CPY OBJ(''%OBJ%'') TOOBJ(''%TOOBJ%'')';
  //
/COPY QIFS2,IFS1011  Directory '&1' does not exist.
/COPY QIFS2,IFS1012  File '&1' does not exist.
/COPY QIFS2,IFS1013  File '&1' already exits.
/COPY QIFS2,IFS1040  Failed to copy file '&1' to '&2'.
/COPY QIFS2,IFS1041  Options APPEND and REPLACE cannot be ..
/COPY QIFS2,IFS1042  Could not copy '&1' because it is not .
/COPY QIFS2,IFS1045  Failed to retrieve the CCSID of file ..
/COPY QIFS2,IFS1046  Specified CCSID &2 is different from ..
  // ---------------------------------------------------------

  //Process optional parameters ...
  //... i_options
  if (%parms() >= p_options and %addr(i_options) <> *NULL);
    options = i_options;
  else;
    options = cIFS_COPY_FILE_DFT;
  endif;

  //... i_ccsid
  if (%parms() >= p_ccsid and %addr(i_ccsid) <> *NULL);
    ccsid = i_ccsid;
  else;
    ccsid = cIFS_COPY_FILE_CCSID_SAME;
  endif;

  msg = AppMsg_new(cMsg_ID_OK);

  dou '1';

    //Ensure that APPEND and REPLACE are not specified together.
    if (f_isBitOn(cIFS_COPY_FILE_APPEND : options) and
        f_isBitOn(cIFS_COPY_FILE_REPLACE: options));
      clear IFS1041;
      Application_killWithMsg(AppMsg_newEscape('IFS1041': IFS1041));
    endif;

    //If the FROM object is a directory, ...
    if (ifsDirectory_exist(i_fromPath));
      //... then create an error message
      clear IFS1042;
      IFS10421 = i_fromPath;
      msg = AppMsg_newEscape('IFS1042': IFS1042);
      rc = cIFS_ERROR;
      leave;
    endif;

    //If the file does not exist, ...
    if (not ifsFile_exist(i_fromPath));
      //... then create an error message
      clear IFS1012;
      IFS10121 = i_fromPath;
      msg = AppMsg_newEscape('IFS1012': IFS1012);
      rc = cIFS_ERROR;
      leave;
    endif;

    //Compute path of target file
    if (ifsPath_isDirectory(i_toPath) or ifsDirectory_exist(i_toPath));
      toFile      = ifsPath_getName(i_fromPath);
      toDirectory = ifsDirectory_fixSyntax(i_toPath);
    else;
      toFile      = ifsPath_getName(i_toPath);
      toDirectory = ifsPath_getDirectory(i_toPath);
      if (toDirectory = '');
        toDirectory = ifsPath_getDirectory(i_fromPath);
      endif;
      if (toDirectory = '');
        toDirectory = ifsDirectory_fixSyntax('.');
      endif;
    endif;

    toPath = ifsPath_fixSyntax(toDirectory + toFile);

    //If the target file does already exist, ...
    fileExist = ifsFile_exist(toPath);

    //... delete it or switch to append mode, if allowed
    if (fileExist);
      if (f_isBitOn(cIFS_COPY_FILE_REPLACE: options));
        if (ifsFile_delete(toPath: msg) = cIFS_ERROR);
          rc = cIFS_ERROR;
          leave;
        endif;
      endif;
      if (f_isBitOn(cIFS_COPY_FILE_APPEND: options));
        appendFile = cTrue;
      endif;
    endif;

    if (not appendFile and ifsFile_exist(toPath));
      //... then create error message
      clear IFS1013;
      IFS10131 = toPath;
      msg = AppMsg_newEscape('IFS1013': IFS1013);
      rc = cIFS_ERROR;
      leave;
    endif;

    //Check CCSID if data is going to be added to the target file
    if (appendFile and ccsid <> cIFS_COPY_FILE_CCSID_SAME);
      if (stat(toPath: %addr(st_stat)) = RC_ERROR);
        clear IFS1045;            //Failed to retrieve CCSID
        IFS10451 = toPath;
        IFS10452 = f_errno();
        IFS10453 = f_strerror(f_errno());
        msg = AppMsg_newEscape('IFS1045': IFS1045);
        rc = cIFS_ERROR;
        leave;
      endif;
      if (ccsid <> st_stat.ccsid);
        clear IFS1046;            //CCSIDs are not equal
        IFS10461 = toPath;
        IFS10462 = ccsid;
        IFS10463 = st_stat.ccsid;
        msg = AppMsg_newEscape('IFS1046': IFS1046);
        rc = cIFS_ERROR;
        leave;
      endif;
    endif;

    //If the target directory does not exist, ...
    if (not ifsDirectory_exist(toDirectory));
      if (not f_isBitOn(cIFS_COPY_FILE_CREATE_DIRECTORY: options));
        //... then create error message
        clear IFS1011;
        IFS10111 = toDirectory;
        msg = AppMsg_newEscape('IFS1011': IFS1011);
        rc = cIFS_ERROR;
        leave;
      endif;

      if (ifsDirectory_create(
             toDirectory: cIFS_MKDIR_SUBDIR: *omit: msg) = cIFS_ERROR);
        rc = cIFS_ERROR;
        leave;
      endif;
    endif;

    //Copy stream file
    if (appendFile or ccsid <> cIFS_COPY_FILE_CCSID_SAME);
      if (not copyFileCreateOrAppend(i_fromPath: toPath: ccsid: msg));
        Application_killWithMsg(msg);
      //rc = cIFS_ERROR;
      //leave;
      endif;
    else;
      cmd = f_replace('%OBJ%'  : i_fromPath: CMD_CPY);
      cmd = f_replace('%TOOBJ%': toPath    : cmd);

      //If we got an error, ...
      if (not f_execute(cmd: cCMD_PRC_EXC_QCMDEXC: msg));
        //... then create error message
        clear IFS1040;
        IFS10401 = i_fromPath;
        IFS10402 = toPath;
        IFS10403 = msg.ID;
        IFS10404 = f_rtvMsgText(msg);
        msg = AppMsg_newEscape('IFS1040': IFS1040);
        rc = cIFS_ERROR;
        leave;
      endif;
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
//  Sets the read/write pointer of an open stream file to a new position.
//=========================================================================
//  Parameters:
//   i_hFile       - The handle of a file opened by ifsFile_open().
//   i_offset      - The new position of the read/write pointer.
//   i_whence      - The base position to count i_offset from:
//                   SEEK_SET       The start of the file.
//                   SEEK_CUR       The current file offset in the file.
//                   SEEK_END       The end of the file.
//   o_msg         - Error message.
//
//  Returns:
//   rc            - Returns the file size on success, else cIFS_ERROR.
//=========================================================================
DCL-PROC ifsFile_seek EXPORT;
  //
  DCL-PI *N INT(10);
    i_hFile  CONST LIKE(ifs_hFile_t);
    i_offset INT(10) CONST;
    i_whence INT(10) CONST;
    o_msg    LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;
  //
  //  Return value
  DCL-S newOffset INT(10) INZ;
  //
  //  Parameter positions
  DCL-C p_msg 4;
  //
  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  Helper fields
  //
  //  File handle
  DCL-DS handle LIKEDS(handle_t) BASED(pHandle);
  //
/COPY QIFS2,IFS1008  Failed to set read/write offset of ...
  // ---------------------------------------------------------

  //Check assurances
  p_assert((i_whence = SEEK_SET)  or
           (i_whence = SEEK_CUR)  or
           (i_whence = SEEK_END)                                   :
           'Invalid parameter for i_whence.'                       );

  //Get access to file handle date
  pHandle = HANDLE_getPointer(i_hFile);

  //Set the the new file offset
  newOffset = lseek(handle.hFileUnix: i_offset: i_whence);

  //If we got an error message, ...
  if (newOffset = RC_ERROR);
    //... create error message
    clear IFS1008;
    IFS10081 = handle.path;
    IFS10082 = f_errno();
    IFS10083 = f_strerror(f_errno());
    IFS10084 = i_offset;
    IFS10085 = i_whence;
    msg = AppMsg_newEscape('IFS1008': IFS1008);
    newOffset = cIFS_ERROR;
  else;
    //... else create OK message
    msg = AppMsg_new(cMsg_ID_OK);
    newOffset = cIFS_OK;
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

  return newOffset;

//
END-PROC;
//
//=========================================================================
//  Reads data from a given stream file.
//=========================================================================
//  Parameters:
//   i_hFile       - The handle of a file opened by ifsFile_open().
//   i_pBuffer     - A pointer to the input data.
//   i_length      - The length of the buffer.
//   o_msg         - Error message.
//
//  Returns:
//   rc            - Returns the number of bytes that were red from
//                   the IFS file or cIFS_ERROR.
//=========================================================================
DCL-PROC ifsFile_read EXPORT;
  //
  DCL-PI *N INT(10);
    i_hFile   CONST LIKE(ifs_hFile_t);
    i_pBuffer POINTER CONST;
    i_length  INT(10) CONST;
    o_msg     LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;
  //
  //  Return value
  DCL-S bytesRed INT(10) INZ;
  //
  //  Parameter positions
  DCL-C p_msg 4;
  //
  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  Helper fields
  DCL-S tmpRC INT(10) INZ;
  //
  //  File handle
  DCL-DS handle LIKEDS(handle_t) BASED(pHandle);
  //
/COPY QIFS2,IFS1004  Failed to read data from file '&1'.
  // ---------------------------------------------------------

  //Get access to file handle date
  pHandle = HANDLE_getPointer(i_hFile);

  //Read data from the IFS file
  tmpRC = read(handle.hFileUnix: i_pBuffer: i_length);

  //If we got an error ...
  if (tmpRC = RC_ERROR);
    //... then create error message
    clear IFS1004;
    IFS10041 = handle.path;
    IFS10042 = f_errno();
    IFS10043 = f_strerror(f_errno());
    msg = AppMsg_newEscape('IFS1004': IFS1004);
    bytesRed = cIFS_ERROR;
  else;
    //clear message
    msg = AppMsg_new(cMsg_ID_OK);
    bytesRed = tmpRC;
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

  return bytesRed;

//
END-PROC;
//
//=========================================================================
//  Writes data to a given stream file.
//=========================================================================
//  Parameters:
//   i_hFile       - The handle of a file opened by ifsFile_open().
//   i_pBuffer     - A pointer to the data to write to the IFS file.
//   i_length      - The length of the data or 0 is the data is a
//                   null-terminated string.
//   o_msg         - Error message.
//
//  Returns:
//   rc            - Returns the number of bytes that have been written
//                   to the stream file on success, else cIFS_ERROR.
//=========================================================================
DCL-PROC ifsFile_write EXPORT;
  //
  DCL-PI *N INT(10);
    i_hFile   CONST LIKE(ifs_hFile_t);
    i_pBuffer POINTER CONST OPTIONS(*STRING);
    i_length  INT(10) CONST;
    o_msg     LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;
  //
  //  Return value
  DCL-S bytesWritten INT(10) INZ;
  //
  //  Parameter positions
  DCL-C p_msg 4;
  //
  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  Helper fields
  DCL-S length INT(10) INZ;
  DCL-S tmpRC INT(10) INZ;
  //
  //  File handle
  DCL-DS handle LIKEDS(handle_t) BASED(pHandle);
  //
/COPY QIFS2,IFS1002  Failed to write data to file '&1'.
  // ---------------------------------------------------------

  //Get access to file handle date
  pHandle = HANDLE_getPointer(i_hFile);

  //Get the buffer length if the length is specified as -1
  if (i_length = 0);
    length = strlen(i_pBuffer);
  else;
    length = i_length;
  endif;

  //Write data to IFS file
  tmpRC = write(handle.hFileUnix: i_pBuffer: length);

  //If we got an error
  if (tmpRC = RC_ERROR);
    //... then create error message
    clear IFS1002;
    IFS10021 = handle.path;
    IFS10022 = f_errno();
    IFS10023 = f_strerror(f_errno());
    msg = AppMsg_newEscape('IFS1002': IFS1002);
    bytesWritten = cIFS_ERROR;
  else;
    //clear message
    msg = AppMsg_new(cMsg_ID_OK);
    bytesWritten = tmpRC;
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

  return bytesWritten;

//
END-PROC;
//
//=========================================================================
//  Reads a line from a given stream file.
//=========================================================================
//  Parameters:
//   i_hFile       - The handle of a file opened by ifsFile_open().
//   i_pBuffer     - A pointer to the input data.
//   i_length      - The length of the buffer.
//   i_EOLChar     - End-Of-Line character string.
//                   Default:        cIFS_EOL_CRLF
//                   cIFS_EOL_CRLF - Ascii 0D+0A, typically used
//                                   by DOS and Windows systems.
//                   cIFS_EOL_LF   - Ascii 0A, typically used
//                                   by Unix systems.
//                   cIFS_EOL_CR   - Ascii 0D, typically used
//                                   by Mac systems.
//   o_msg         - Error message.
//
//  Returns:
//   rc            - Returns the number of bytes that were red from
//                   the file or cIFS_ERROR. Returns cIFS_EOL
//                   in case of EOF.
//
//  Comments:
//   A line is considered as a series of bytes terminated by an
//   End-Of-Line character. The EOL-character is not added to the
//   buffer addressed by i_pBuffer.
//   By default der ifsFile_readLine() procedure uses CR+LF as
//   the EOL-characters. Since DOS/Windows, Unix and Mac uses different
//   EOL-characters, the EOL-character to be use can be specified at
//   i_EOLChar.
//   Notice that beside the predefined constants you can use any other
//   character or character string up to 32 byte as the EOL-character.
//
//=========================================================================
DCL-PROC ifsFile_readLine EXPORT;
  //
  DCL-PI *N INT(10);
    i_hFile   CONST LIKE(ifs_hFile_t);
    i_pBuffer POINTER CONST;
    i_length  INT(10) CONST;
    i_EOLChar CONST LIKE(ifs_EOLChar_t) OPTIONS(*NOPASS: *OMIT);
    o_msg     LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;
  //
  //  Return value
  DCL-S bytesRed INT(10) INZ;
  //
  //  Parameter positions
  DCL-C p_EOLChar 4;
  DCL-C p_msg 5;
  //
  //  Fields for optional parameters
  DCL-S eolChar LIKE(i_EOLChar) INZ;
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  Helper fields
  DCL-S bytesLeft INT(10) INZ;
  DCL-S bytesTotal INT(10) INZ;
  DCL-S bytesCpy INT(10) INZ;
  DCL-S a1ByteBuffer CHAR(1) INZ;
  DCL-S pBuffer POINTER INZ;
  DCL-S ofsOutBuffer LIKE(i_length) INZ(0);
  //
  DCL-DS EOLBuffer QUALIFIED;
    mustFlush IND INZ(cFalse);
    data      LIKE(ifs_EOLChar_t) INZ;
  END-DS;
  //
  //  File handle
  DCL-DS handle LIKEDS(handle_t) BASED(pHandle);
  //
/COPY QIFS2,IFS1016  Buffer overflow while reading from ...
  // ---------------------------------------------------------

  //Get optional parameters ...
  //... EOL-character (string)
  if (%parms() >= p_EOLChar and %addr(i_EOLChar) <> *NULL);
    EOLChar = i_EOLChar;
  else;
    EOLChar = cIFS_EOL_CRLF;
  endif;

  //Get access to file handle date
  pHandle = HANDLE_getPointer(i_hFile);

  //Initialized the remaining size of the output buffer
  bytesLeft = i_length;

  //Read until EOL-charcater
  dou (EOLbuffer.data = EOLChar);

    //Add bytes red to output buffer
    dow (bytesTotal > 0 and bytesLeft > 0);

      if (EOLBuffer.mustFlush);
        pBuffer  = %addr(EOLBuffer.data) + 2;
        if (%len(EOLBuffer.data) > bytesLeft);
          bytesCpy = bytesLeft;
        else;
          bytesCpy = %len(EOLBuffer.data);
        endif;
      else;
        pBuffer  = %addr(a1ByteBuffer);
        bytesCpy = 1;
      endif;

      memcpy(i_pBuffer + ofsOutBuffer: pBuffer: bytesCpy);
      ofsOutBuffer = ofsOutBuffer + bytesCpy;
      bytesRed   = bytesRed + bytesCpy;
      bytesTotal = bytesTotal - bytesCpy;
      bytesLeft  = bytesLeft  - bytesCpy;

      if (EOLBuffer.mustFlush);
        EOLBuffer.data = '';
        EOLBuffer.mustFlush = cFalse;
      endif;

    enddo;

    //Check the number of bytes that could not be
    //copied to the output buffer
    if (bytesTotal > 0);
      //... create error message on buffer overflow
      clear IFS1016;
      IFS10161 = handle.path;
      IFS10162 = i_length;
      msg = AppMsg_newEscape('IFS1016': IFS1016);
      leave;
    endif;

    //Read data from the stream file
    bytesTotal = ifsFile_read(i_hFile: %addr(a1ByteBuffer): 1: msg);

    //If we got an error ...
    if (msg.ID <> cMSG_ID_OK);
      //... return error message
      bytesRed = -1;
      leave;
    endif;

    //If we reached EOF ...
    if (bytesTotal = 0);
      //... cancel loop
      if (bytesRed = 0);
        bytesRed = cIFS_EOF;
      endif;
      leave;
    endif;

    //Append the byte we just red to the EOL buffer
    //in case the byte red matches the next byte we
    //expect:
    if (a1ByteBuffer = %subst(EOLChar: %len(EOLBuffer.data) + 1: 1));
      EOLBuffer.data = EOLBuffer.data + a1ByteBuffer;
      bytesTotal = 0;
    else;
      if (%len(EOLBuffer.data) > 0);
        EOLBuffer.mustFlush = cTrue;
        bytesTotal = bytesTotal + %len(EOLBuffer.data);
      endif;
    endif;

  enddo;

  //Strip the EOL-character (string) from the output buffer
  //in case we left the loop due to EOL condition:
  //(Remind that the last byte of the EOL-character was
  // not yet added to the output buffer!)
  //if (EOLbuffer.data = EOLChar);
  //   bytesRed = bytesRed - (%len(EOLChar) - 1);
  //endif;

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

  return bytesRed;

//
END-PROC;
//
//=========================================================================
//  Writes line to a given stream file.
//=========================================================================
//  Parameters:
//   i_hFile       - The handle of a file opened by ifsFile_open().
//   i_pBuffer     - A pointer to the data to write to the IFS file.
//   i_length      - The length of the data or 0 is the data is a
//                   null-terminated string.
//   i_EOLChar     - End-Of-Line character string.
//                   Default:        cIFS_EOL_CRLF
//                   cIFS_EOL_CRLF - Ascii 0D+0A, typically used
//                                   by DOS and Windows systems.
//                   cIFS_EOL_LF   - Ascii 0A, typically used
//                                   by Unix systems.
//                   cIFS_EOL_CR   - Ascii 0D, typically used
//                                   by Mac systems.
//   o_msg         - Error message.
//
//  Returns:
//   rc            - Returns the number of bytes that were written to
//                   the IFS file or cIFS_ERROR.
//
//  Comments:
//   A line is considered as a series of bytes terminated by an
//   End-Of-Line character. The EOL-character must not be included in
//   the buffer addressed by i_pBuffer. It is automatically added.
//   By default the ifsFile_writeLine() procedure uses CR+LF as
//   the EOL-characters. Since DOS/Windows, Unix and Mac uses different
//   EOL-characters, the EOL-character to be use can be specified at
//   i_EOLChar.
//   Notice that beside the predefined constants you can use any other
//   character or character string up to 32 byte as the EOL-character.
//
//  Hint:
//   Usually ifsFile_writeLine() uses separate write operation to
//   write the data and the end-of-line characters to the file. If
//   a file is shared with other writers, data and EOL characters
//   have to be written in a single, atomic operation. Otherwise
//   the output data can get mixed up with the data of other writers.
//   In those cases ifsFile_writeLine() uses a temporary buffer to
//   ensure that the data and the EOL characters are written at once.
//   Of course that reduces performance.
//   In order to gain better performance you may add the EOL characters
//   manually before calling ifsFile_writeLine(). In that case specify
//   and empty string for the EOL characters at ifsFile_writeLine().
//
//   Sample:
//
//     data = 'Hello World' + cIFS_EOL_CRLF;
//     rc = ifsFile_writeLine(hFile
//                            : %addr(data)
//                            : %len(data)
//                            : ''
//                            : msg);
//     if (rc > 0);
//        numBytes = rc - %len(cIFS_EOL_CRLF);
//     endif;
//
//=========================================================================
DCL-PROC ifsFile_writeLine EXPORT;
  //
  DCL-PI *N INT(10);
    i_hFile   CONST LIKE(ifs_hFile_t);
    i_pBuffer POINTER CONST OPTIONS(*STRING);
    i_length  INT(10) CONST;
    i_EOLChar CONST LIKE(ifs_EOLChar_t) OPTIONS(*NOPASS: *OMIT);
    o_msg     LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;
  //
  //  Return value
  DCL-S bytesWritten INT(10) INZ;
  //
  //  Parameter positions
  DCL-C p_EOLChar 4;
  DCL-C p_msg 5;
  //
  //  Fields for optional parameters
  DCL-S eolChar LIKE(i_EOLChar) INZ;
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  Helper fields
  DCL-S length INT(10) INZ;
  DCL-S lengthEOL INT(10) INZ;
  DCL-S startPos INT(10) INZ;
  DCL-S numBytes INT(10) INZ;
  DCL-S newSize INT(10) INZ;
  DCL-S EOLBuffer CHAR(32) BASED(pEOLBuffer);
  DCL-S pBuffer POINTER INZ;
  DCL-S x INT(10) INZ;
  //
  //  File handle
  DCL-DS handle LIKEDS(handle_t) BASED(pHandle);
  // ---------------------------------------------------------

  //Get optional parameters ...
  //... EOL-character (string)
  if (%parms() >= p_EOLChar and %addr(i_EOLChar) <> *NULL);
    EOLChar = i_EOLChar;
  else;
    EOLChar = cIFS_EOL_CRLF;
  endif;

  //Get access to file handle date
  pHandle = HANDLE_getPointer(i_hFile);

  //Get the buffer length if the length is specified as 0
  if (i_length = 0);
    length = strlen(i_pBuffer);
  else;
    length = i_length;
  endif;

  //Use temporary buffer when file is shared with other writers
  if (%len(EOLChar) > 0 and handle.useWriteBuffer);

    //Check buffer size, reallocate buffer if necessary
    newSize = length + %len(EOLChar);
    pBuffer = checkHandleBufferSizeAndReallocate(handle.writeBuffer
                                                 : newSize);

    //Copy input buffer to temporary write buffer
    memcpy(pBuffer: i_pBuffer: length);

    //Add EOL-character (string)
    pEOLBuffer = pBuffer + length;
    %subst(EOLBuffer: 1: %len(EOLChar)) = EOLChar;

    //Adjust length of buffer
    length = newSize;

    //Clear EOL characters to avoid to append them twice
    //but remined its length in order to return the correct
    //number of bytes that have been written to the file.
    lengthEOL = %len(EOLChar);
    EOLChar   = '';

  endif;

  //Write data to IFS file
  if (pBuffer <> *NULL);
    bytesWritten = ifsFile_write(i_hFile: pBuffer: length: msg);
  else;
    bytesWritten = ifsFile_write(i_hFile: i_pBuffer: length: msg);
  endif;

  if (bytesWritten > 0);
    bytesWritten = bytesWritten - lengthEOL;
  endif;

  //Add EOL-character (string)
  if (EOLChar <> '' and msg.ID = cMSG_ID_OK);
    numBytes = ifsFile_write(i_hFile: EOLChar: %len(EOLChar): msg);
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

  return bytesWritten;

//
END-PROC;
//
//=========================================================================
//  Returns the size on a given stream file.
//=========================================================================
//  Parameters:
//   i_path        - The path name of a given IFS file.
//   o_msg         - Error message.
//
//  Returns:
//   fileSize      - Size of the stream file on success, else cIFS_ERROR.
//=========================================================================
DCL-PROC ifsFile_getSize EXPORT;
  //
  DCL-PI *N INT(10);
    i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;
  //
  //  Return value
  DCL-S fileSize INT(10) INZ;
  //
  //  Parameter positions
  DCL-C p_msg 2;
  //
  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  Helper fields
  DCL-S tmpRC INT(10) INZ;
  //
  //  stat() result data structure
  DCL-DS st_stat LIKEDS(st_stat_t) INZ;
  //
/COPY QIFS2,IFS1006  Failed to retrieve the size of file '&1
  // ---------------------------------------------------------

  //Get the size of the stream file
  tmpRC = stat(ifsPath_fixSyntax(i_path): %addr(st_stat));

  if (tmpRC = RC_ERROR);
    clear IFS1006;
    IFS10061 = i_path;
    IFS10062 = f_errno();
    IFS10063 = f_strerror(f_errno());
    msg = AppMsg_newEscape('IFS1006': IFS1006);
    fileSize = cIFS_ERROR;
  else;
    msg = AppMsg_new(cMsg_ID_OK);
    fileSize = st_stat.size;
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

  return fileSize;

//
END-PROC;
//
//=========================================================================
//  Returns the size of the file referenced by a given file handle.
//=========================================================================
//  Parameters:
//   i_hFile       - The handle of a file opened by ifsFile_open().
//   o_msg         - Error message.
//
//  Returns:
//   fileSize      - Size of the stream file on success, else cIFS_ERROR.
//=========================================================================
DCL-PROC ifsFile_getSizeH EXPORT;
  //
  DCL-PI *N INT(10);
    i_hFile CONST LIKE(ifs_hFile_t);
    o_msg   LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;
  //
  //  Return value
  DCL-S fileSize INT(10) INZ;
  //
  //  Parameter positions
  DCL-C p_msg 2;
  //
  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  Helper fields
  DCL-S tmpRC INT(10) INZ;
  //
  //  stat() result data structure
  DCL-DS st_stat LIKEDS(st_stat_t) INZ;
  //
  //  File handle
  DCL-DS handle LIKEDS(handle_t) BASED(pHandle);
  //
/COPY QIFS2,IFS1006  Failed to retrieve the size of file '&1
  // ---------------------------------------------------------

  //Get access to file handle date
  pHandle = HANDLE_getPointer(i_hFile);

  //Get the size of the stream file
  tmpRC = fstat(handle.hFileUnix: st_stat);

  if (tmpRC = RC_ERROR);
    clear IFS1006;
    IFS10061 = handle.path;
    IFS10062 = f_errno();
    IFS10063 = f_strerror(f_errno());
    msg = AppMsg_newEscape('IFS1006': IFS1006);
    fileSize = cIFS_ERROR;
  else;
    msg = AppMsg_new(cMsg_ID_OK);
    fileSize = st_stat.size;
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

  return fileSize;

//
END-PROC;
//
//=========================================================================
//  Changes the size on a given stream file.
//=========================================================================
//  Parameters:
//   i_path        - The path name of a given IFS file.
//   o_msg         - Error message.
//
//  Returns:
//   fileSize      - New size of the stream file on success, else
//                   cIFS_ERROR.
//=========================================================================
DCL-PROC ifsFile_setSize EXPORT;
  //
  DCL-PI *N INT(10);
    i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;
  //
  //  Return value
  DCL-S fileSize INT(10) INZ;
  //
  //  Parameter positions
  DCL-C p_msg 2;
  //
  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  Helper fields
  DCL-S tmpRC INT(10) INZ;
  //
/COPY QIFS2,IFS1007  Failed to change size of file '&1'.
  // ---------------------------------------------------------

  p_assert(cFalse: f_this() + ': not yet implemented');

  if (tmpRC = RC_ERROR);
    clear IFS1007;
    IFS10071 = i_path;
    IFS10072 = f_errno();
    IFS10073 = f_strerror(f_errno());
    msg = AppMsg_newEscape('IFS1007': IFS1007);
    fileSize = cIFS_ERROR;
  else;
    msg = AppMsg_new(cMsg_ID_OK);
    fileSize = tmpRC;
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

  return fileSize;

//
END-PROC;
//
//=========================================================================
//  Changes the size of the file referenced by a given file handle.
//=========================================================================
//  Parameters:
//   i_hFile       - The handle of a file opened by ifsFile_open().
//   i_newSize     - The new size of the IFS file.
//   o_msg         - Error message.
//
//  Returns:
//   fileSize      - New size of the stream file on success, else
//                   cIFS_ERROR.
//=========================================================================
DCL-PROC ifsFile_setSizeH EXPORT;
  //
  DCL-PI *N INT(10);
    i_hFile   CONST LIKE(ifs_hFile_t);
    i_newSize INT(10) CONST;
    o_msg     LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;
  //
  //  Return value
  DCL-S fileSize INT(10) INZ;
  //
  //  Parameter positions
  DCL-C p_msg 3;
  //
  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  Local fields
  DCL-S tmpRC INT(10) INZ;
  //
  //  File handle
  DCL-DS handle LIKEDS(handle_t) BASED(pHandle);
  //
/COPY QIFS2,IFS1007  Failed to change size of file '&1'.
  // ---------------------------------------------------------

  //Get access to file handle date
  pHandle = HANDLE_getPointer(i_hFile);

  //Set the new size of the IFS file
  tmpRC = ftruncate(i_hFile: i_newSize);

  //If we got an error, ...
  if (tmpRC = RC_ERROR);
    clear IFS1007;
    IFS10071 = handle.path;
    IFS10072 = f_errno();
    IFS10073 = f_strerror(f_errno());
    msg = AppMsg_newEscape('IFS1007': IFS1007);
    fileSize = cIFS_ERROR;
  else;
    msg = AppMsg_new(cMsg_ID_OK);
    fileSize = tmpRC;
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

  return fileSize;

//
END-PROC;
//
//=========================================================================
//  Returns the creation timestamp of a given stream file.
//=========================================================================
//  Parameters:
//   i_path        - The path name of a given stream file.
//   o_msg         - Error message.
//
//  Returns:
//   crtTime       - Timestamp the file was created on success, else
//                   *LOVAL.
//=========================================================================
DCL-PROC ifsFile_getCreationTime EXPORT;
  //
  DCL-PI *N TIMESTAMP;
    i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
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
/COPY QIFS2,IFS1021  Failed to retrieve the timestamp the ..
  // ---------------------------------------------------------

  //Retrieve file creation time ...
  tmpRC = FileAttr_getTime(ifsPath_fixSyntax(i_path)
                           : QP0L_ATTR_CREATE_TIME: tmpCrtTime);
  if (tmpRC = RC_ERROR);
    clear IFS1021;
    IFS10211 = i_path;
    IFS10212 = f_errno();
    IFS10213 = f_strerror(f_errno());
    msg = AppMsg_newEscape('IFS1021': IFS1021);
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
//  Returns the timestamp the stream file data was last changed.
//=========================================================================
//  Parameters:
//   i_path        - The path name of a given stream file.
//   o_msg         - Error message.
//
//  Returns:
//   chgTime       - Timestamp the stream file data was last changed
//                   on success, else *LOVAL;
//=========================================================================
DCL-PROC ifsFile_getDataChangeTime EXPORT;
  //
  DCL-PI *N TIMESTAMP;
    i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
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
/COPY QIFS2,IFS1022  Failed to retrieve the timestamp the ..
  // ---------------------------------------------------------

  //Retrieve the time the file data was last changed ...
  tmpRC = FileAttr_getTime(ifsPath_fixSyntax(i_path)
                           : QP0L_ATTR_MODIFY_TIME: tmpChgTime);
  if (tmpRC = RC_ERROR);
    clear IFS1022;
    IFS10221 = i_path;
    IFS10222 = f_errno();
    IFS10223 = f_strerror(f_errno());
    msg = AppMsg_newEscape('IFS1022': IFS1022);
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
//  Returns the file ID that uniquely identifies a given stream file.
//=========================================================================
//  Parameters:
//   i_path        - The name of a given stream file.
//   o_msg         - Error message.
//
//  Returns:
//   fileID        - Returns the file ID on success, else cIFS_ERROR.
//=========================================================================
DCL-PROC ifsFile_getUniqueID EXPORT;
  //
  DCL-PI *N LIKEDS(ifs_uniqueFileID_t);
    i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;
  //
  //  Return value
  DCL-DS fileID LIKEDS(ifs_uniqueFileID_t) INZ;
  //
  //  Parameter positions
  DCL-C p_msg 2;
  //
  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  Local fields
  DCL-S tmpRC INT(10) INZ;
  //
  //  stat() result data structure
  DCL-DS st_stat LIKEDS(st_stat_t) INZ;
  //
/COPY QIFS2,IFS1028  Failed to retrieve the unique file ID .
  // ---------------------------------------------------------

  //Get the file ID of the stream file
  tmpRC = stat(ifsPath_fixSyntax(i_path): %addr(st_stat));

  if (tmpRC = RC_ERROR);
    clear IFS1028;
    IFS10281 = i_path;
    IFS10282 = f_errno();
    IFS10283 = f_strerror(f_errno());
    msg = AppMsg_newEscape('IFS1028': IFS1028);
    fileID.ino = RC_ERROR;
    fileID.dev = RC_ERROR;
  else;
    msg = AppMsg_new(cMsg_ID_OK);
    fileID = produceUniqueFileID(st_stat);
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

  return fileID;

//
END-PROC;
//
//=========================================================================
//  Returns the unique file ID of the file referenced by a
//  given file handle.
//=========================================================================
//  Parameters:
//   i_hFile       - The handle of a file opened by ifsFile_open().
//   o_msg         - Error message.
//
//  Returns:
//   fileID        - Returns the file ID on success, else cIFS_ERROR.
//=========================================================================
DCL-PROC ifsFile_getUniqueIDH EXPORT;
  //
  DCL-PI *N LIKEDS(ifs_uniqueFileID_t);
    i_hFile CONST LIKE(ifs_hFile_t);
    o_msg   LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;
  //
  //  Return value
  DCL-DS fileID LIKEDS(ifs_uniqueFileID_t) INZ;
  //
  //  Parameter positions
  DCL-C p_msg 2;
  //
  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  Local fields
  DCL-S tmpRC INT(10) INZ;
  //
  //  stat() result data structure
  DCL-DS st_stat LIKEDS(st_stat_t) INZ;
  //
  //  File handle
  DCL-DS handle LIKEDS(handle_t) BASED(pHandle);
  //
/COPY QIFS2,IFS1028  Failed to retrieve the unique file ID .
  // ---------------------------------------------------------

  //Get access to file handle date
  pHandle = HANDLE_getPointer(i_hFile);

  //Get the file ID of the stream file
  tmpRC = fstat(handle.hFileUnix: st_stat);

  if (tmpRC = RC_ERROR);
    clear IFS1028;
    IFS10281 = handle.path;
    IFS10282 = f_errno();
    IFS10283 = f_strerror(f_errno());
    msg = AppMsg_newEscape('IFS1028': IFS1028);
    fileID.ino = RC_ERROR;
    fileID.dev = RC_ERROR;
  else;
    msg = AppMsg_new(cMsg_ID_OK);
    fileID = produceUniqueFileID(st_stat);
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

  return fileID;

//
END-PROC;
//
//=========================================================================
//  Returns the file ID as shown at the WRKLNK 'Display Attributes' screen.
//=========================================================================
//  Parameters:
//   i_path        - The name of a given stream file.
//   o_msg         - Error message.
//
//  Returns:
//   fileID        - Returns the file ID on success, else an empty string.
//=========================================================================
DCL-PROC ifsFile_getID EXPORT;
  //
  DCL-PI *N LIKE(ifs_fileID_t);
    i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;
  //
  //  Return value
  DCL-S fileID LIKE(ifs_fileID_t) INZ;
  //
  //  Parameter positions
  DCL-C p_msg 2;
  //
  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  Local fields
  DCL-S tmpRC INT(10) INZ;
  //
  //  stat() result data structure
  DCL-DS st_stat LIKEDS(st_stat_t) INZ;
  //
/COPY QIFS2,IFS1037  Failed to retrieve the file ID ...
  // ---------------------------------------------------------

  //Get the file ID of the stream file
  tmpRC = stat(ifsPath_fixSyntax(i_path): %addr(st_stat));

  if (tmpRC = RC_ERROR);
    clear IFS1037;
    IFS10371 = i_path;
    IFS10372 = f_errno();
    IFS10373 = f_strerror(f_errno());
    msg = AppMsg_newEscape('IFS1037': IFS1037);
    fileID = '';
  else;
    msg = AppMsg_new(cMsg_ID_OK);
    fileID = produceFileID(st_stat);
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

  return fileID;

//
END-PROC;
//
//=========================================================================
//  Returns the file ID of the file referenced by a given file handle
//   as shown at the WRKLNK 'Display Attributes' screen.
//=========================================================================
//  Parameters:
//   i_hFile       - The handle of a file opened by ifsFile_open().
//   o_msg         - Error message.
//
//  Returns:
//   fileID        - Returns the file ID on success, else an empty string.
//=========================================================================
DCL-PROC ifsFile_getIDH EXPORT;
  //
  DCL-PI *N LIKE(ifs_fileID_t);
    i_hFile CONST LIKE(ifs_hFile_t);
    o_msg   LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;
  //
  //  Return value
  DCL-S fileID LIKE(ifs_fileID_t) INZ;
  //
  //  Parameter positions
  DCL-C p_msg 2;
  //
  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  Local fields
  DCL-S tmpRC INT(10) INZ;
  //
  //  stat() result data structure
  DCL-DS st_stat LIKEDS(st_stat_t) INZ;
  //
  //  File handle
  DCL-DS handle LIKEDS(handle_t) BASED(pHandle);
  //
/COPY QIFS2,IFS1037  Failed to retrieve the file ID ...
  // ---------------------------------------------------------

  //Get access to file handle date
  pHandle = HANDLE_getPointer(i_hFile);

  //Get the file ID of the stream file
  tmpRC = fstat(handle.hFileUnix: st_stat);

  if (tmpRC = RC_ERROR);
    clear IFS1037;
    IFS10371 = handle.path;
    IFS10372 = f_errno();
    IFS10373 = f_strerror(f_errno());
    msg = AppMsg_newEscape('IFS1037': IFS1037);
    fileID = '';
  else;
    msg = AppMsg_new(cMsg_ID_OK);
    fileID = produceFileID(st_stat);
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

  return fileID;

//
END-PROC;
//
//=========================================================================
//  Produces a unique temporary stream file name.
//=========================================================================
//  Parameters:
//   o_msg         - Error message.
//
//  Returns:
//   tmpPath       - Returns a temporary IFS path name on success, else
//                   an empty string.
//=========================================================================
DCL-PROC ifsFile_getTempPath EXPORT;
  //
  DCL-PI *N LIKE(ifs_path_t);
    o_msg LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;
  //
  //  Return value
  DCL-S tmpPath LIKE(ifs_path_t) INZ;
  //
  //  Parameter positions
  DCL-C p_msg 1;
  //
  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  Helper fields
  DCL-S pTmpPath POINTER INZ;
  //
  //  Helper fields
  //
/COPY QIFS2,IFS1023  Failed to produce temporary path name.
  // ---------------------------------------------------------

  //Produce temporary path name ...
  f_clrErrno();

  pTmpPath = ifs_tmpnam(*NULL);

  if (pTmpPath <> *NULL);
    tmpPath = %str(pTmpPath);
    msg = AppMsg_new(cMsg_ID_OK);
  else;
    clear IFS1023;
    IFS10231 = f_errno();
    IFS10232 = f_strerror(f_errno());
    msg = AppMsg_newEscape('IFS1023': IFS1023);
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

  return tmpPath;

//
END-PROC;
//
//=========================================================================
//  Compares the content of two files with each other.
//=========================================================================
//  Parameters:
//   i_path1       - The name of a given stream file.
//   i_path2       - The name of a given stream file.
//   i_options     - Optional. Compare options. (Not yet used.)
//   o_msg         - Error message.
//
//  Returns:
//   rc            - Returns cIFS_OK on success, else cIFS_ERROR.
//=========================================================================
DCL-PROC ifsFile_compare EXPORT;
  //
  DCL-PI *N INT(10);
    i_path1   CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    i_path2   CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    i_options INT(10) CONST OPTIONS(*NOPASS: *OMIT);
    o_msg     LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;
  //
  //  Return value
  DCL-S rc INT(10) INZ(cIFS_ERROR);
  //
  //  Parameter positions
  DCL-C p_options 3;
  DCL-C p_msg 4;
  //
  //  Fields for optional parameters
  DCL-S options LIKE(i_options) INZ;
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  Local fields
  DCL-S path1 LIKE(i_path1) INZ;
  DCL-S path2 LIKE(i_path2) INZ;
  DCL-S size1 INT(10) INZ;
  DCL-S size2 INT(10) INZ;
  DCL-S fd1 INT(10) INZ(-1);
  DCL-S fd2 INT(10) INZ(-1);
  DCL-S pBuffer1 POINTER INZ;
  DCL-S pBuffer2 POINTER INZ;
  //
  DCL-S BUFF_SIZE INT(10) INZ;
  //
  //  Messages
/COPY QIFS2,IFS1000  Failed to open file '&1'.
/COPY QIFS2,IFS1004  Fehler beim Lesen aus Datei '&1' ...
/COPY QIFS2,IFS1053  Datei stimmen nicht überein.
  // ---------------------------------------------------------

  //Get optional parameters
  //... options
  if (%parms() >= p_options and %addr(i_options) <> *NULL);
    options = i_options;
  else;
    options = 0;
  endif;

  dou '1';

    //Ensure that file 1 exists.
    if (not ifsFile_exist(i_path1: msg));
      leave;
    endif;

    //Ensure that file 2 exists.
    if (not ifsFile_exist(i_path2: msg));
      leave;
    endif;

    //Compare the size of the files
    size1 = ifsFile_getSize(i_path1: msg);
    if (msg.ID <> cMsg_ID_OK);
      leave;
    endif;

    size2 = ifsFile_getSize(i_path2: msg);
    if (msg.ID <> cMsg_ID_OK);
      leave;
    endif;

    if (size1 <> size2);
      clear IFS1053;
      IFS10531 = 1;         //File size
      IFS10532 = i_path1;
      IFS10533 = i_path2;
      msg = AppMsg_newEscape('IFS1053': IFS1053);
      leave;
    endif;

    //Content of the files
    BUFF_SIZE = 1024 * 32;

    path1 = ifsPath_fixSyntax(i_path1);
    fd1 = open(path1: O_RDONLY + O_SHARE_RDONLY);
    if (fd1 = RC_ERROR);
      clear IFS1000;
      IFS10001 = path1;
      IFS10002 = f_errno();
      IFS10003 = f_strerror(f_errno());
      msg = AppMsg_newEscape('IFS1000': IFS1000);
      leave;
    endif;

    path2 = ifsPath_fixSyntax(i_path2);
    fd2 = open(path2: O_RDONLY + O_SHARE_RDONLY);
    if (fd2 = RC_ERROR);
      clear IFS1000;
      IFS10001 = path2;
      IFS10002 = f_errno();
      IFS10003 = f_strerror(f_errno());
      msg = AppMsg_newEscape('IFS1000': IFS1000);
      leave;
    endif;

    pBuffer1 = %alloc(BUFF_SIZE);
    pBuffer2 = %alloc(BUFF_SIZE);

    dou (size1 <= 0 or size2 <= 0);
      size1 = read(fd1: pBuffer1: BUFF_SIZE);
      size2 = read(fd2: pBuffer2: BUFF_SIZE);

      if (size1 = RC_ERROR);
        clear IFS1004;
        IFS10041 = path1;
        IFS10042 = f_errno();
        IFS10043 = f_strerror(f_errno());
        msg = AppMsg_newEscape('IFS1004': IFS1004);
        leave;
      endif;

      if (size2 = RC_ERROR);
        clear IFS1004;
        IFS10041 = path2;
        IFS10042 = f_errno();
        IFS10043 = f_strerror(f_errno());
        msg = AppMsg_newEscape('IFS1004': IFS1004);
        leave;
      endif;

      if (size1 <> size2);
        clear IFS1053;
        IFS10531 = 1;         //File size
        IFS10532 = i_path1;
        IFS10533 = i_path2;
        msg = AppMsg_newEscape('IFS1053': IFS1053);
        leave;
      endif;

      if (size1 > 0 and
          compareBuffers(pBuffer1: pBuffer2: size1) <> cIFS_OK);
        clear IFS1053;
        IFS10531 = 2;         //File content
        IFS10532 = i_path1;
        IFS10533 = i_path2;
        msg = AppMsg_newEscape('IFS1053': IFS1053);
        leave;
      endif;

    enddo;

    dealloc(N) pBuffer1;
    dealloc(N) pBuffer2;

    callp close(fd1);
    fd1 = -1;
    callp close(fd2);
    fd2 = -1;

    if (msg.ID <> cMsg_ID_OK);
      leave;
    endif;

    rc = cIFS_OK;
  enddo;

  //Ensure that files are closed and buffers are deallocated
  if (fd1 <> -1);
    callp close(fd1);
    fd1 = -1;
  endif;

  if (fd2 <> -1);
    callp close(fd2);
    fd1 = -2;
  endif;

  if (pBuffer1 <> *NULL);
    dealloc(N) pBuffer1;
  endif;

  if (pBuffer2 <> *NULL);
    dealloc(N) pBuffer2;
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

  return rc;

//
END-PROC;
//
//=========================================================================
//  *** private ***
//  Checks the size of a given handle buffer and reallocates memory
//  if the buffer is too small.
//=========================================================================
DCL-PROC checkHandleBufferSizeAndReallocate;
  //
  DCL-PI *N POINTER;
    io_buffer LIKEDS(buffer_t);
    i_newSize INT(10) CONST;
  END-PI;
  // ---------------------------------------------------------

  if (i_newSize > io_buffer.size);
    if (io_buffer.pData = *NULL);
      io_buffer.size  = cBUFFER_SIZE;
      io_buffer.pData = %alloc(io_buffer.size);
    else;
      io_buffer.size  = io_buffer.size * 2;
      io_buffer.pData = %realloc(io_buffer.pData: io_buffer.size);
    endif;
  endif;

  p_assert(io_buffer.size > i_newSize
           : 'Handle buffer size too small');

  return io_buffer.pData;

//
END-PROC;
//
//=========================================================================
//  *** private ***
//  Free a given temporary buffer.
//=========================================================================
DCL-PROC freeHandleBuffer;
  //
  DCL-PI *N;
    io_buffer LIKEDS(buffer_t);
  END-PI;
  // ---------------------------------------------------------

  if (io_buffer.pData <> *NULL);
    dealloc(N) io_buffer.pData;
    io_buffer.size = 0;
  endif;

  p_assert(io_buffer.pData = *NULL and io_buffer.size = 0
           : 'Handle buffer not correctly cleared');

  return;

//
END-PROC;
//
//=========================================================================
//  *** private ***
//  Produces a unique file ID.
//=========================================================================
DCL-PROC produceUniqueFileID;
  //
  DCL-PI *N LIKEDS(ifs_uniqueFileID_t);
    i_st_stat CONST LIKEDS(st_stat_t);
  END-PI;
  //
  //  Return value
  DCL-DS fileID LIKEDS(ifs_uniqueFileID_t) INZ;
  // ---------------------------------------------------------

  //---------------------------------------------------------------------- //
  //From the iSeries Information Center V5R4, stat()--Get File Information //
  //---------------------------------------------------------------------- //
  //The file ID for the object. This number uniquely identifies            //
  //the object within a file system. When st_ino and st_dev are            //
  //used together, they uniquely identify the object on the system.        //
  //---------------------------------------------------------------------- //

  fileID.ino = i_st_stat.ino;
  fileID.dev = i_st_stat.dev;

  return fileID;

//
END-PROC;
//
//=========================================================================
//  *** private ***
//  Produces a file ID as shown at the WRKLNK 'Display Attributes' screen.
//=========================================================================
DCL-PROC produceFileID;
  //
  DCL-PI *N LIKE(ifs_fileID_t);
    i_st_stat CONST LIKEDS(st_stat_t);
  END-PI;
  //
  //  Return value
  DCL-S fileID LIKE(ifs_fileID_t) INZ;
  //
  //  Helper fields
  DCL-DS tmpFileID QUALIFIED;
    rdev       UNS(10) INZ; // dev_t  =u
    nlink32    UNS(10) INZ; // nlink32_t
    ino_gen_id UNS(10) INZ; // uint
    ino        UNS(10) INZ; // ino_t  =u
  END-DS;
  // ---------------------------------------------------------

  tmpFileID.rdev       = i_st_stat.rdev;
  tmpFileID.nlink32    = i_st_stat.nlink32;
  tmpFileID.ino_gen_id = i_st_stat.ino_gen_id;
  tmpFileID.ino        = i_st_stat.ino;

  fileID = f_cvtBufferToHexString(%addr(tmpFileID): %size(tmpFileID));

  return fileID;

//
END-PROC;
//
//=========================================================================
//  *** private ***
//  Append the data of a given file to a target file.
//=========================================================================
DCL-PROC copyFileCreateOrAppend;
  //
  DCL-PI *N IND;
    i_fromPath CONST LIKE(ifs_path_t);
    i_toPath   CONST LIKE(ifs_path_t);
    i_toCcsid  CONST LIKE(ifs_ccsid_t);
    o_msg      LIKE(msg_t);
  END-PI;
  //
  //  Return value
  DCL-S isCopied IND INZ(cFalse);
  //
  //  Helper fields
  DCL-S isCodeConversion IND INZ(cFalse);
  DCL-S hFrom INT(10) INZ;
  DCL-S hTo INT(10) INZ;
  DCL-S byteRead INT(10) INZ;
  DCL-S byteWrite INT(10) INZ;
  DCL-S inBufSize UNS(10) INZ;
  DCL-S outBufSize UNS(10) INZ;
  DCL-S pInBuffer POINTER INZ;
  DCL-S pOutBuffer POINTER INZ;
  DCL-S inBuffer CHAR(8192) INZ;
  DCL-S outBuffer CHAR(16384) INZ;
  DCL-S toOptions INT(10) INZ;
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  iconv() helper field s
  DCL-DS hIconv LIKEDS(iconv_t) INZ;
  DCL-DS st_stat_from LIKEDS(st_stat_t) INZ;
  DCL-DS st_stat_to LIKEDS(st_stat_t) INZ;
  //
/COPY QIFS2,IFS1043  Stopped copying file because only &2 ..
/COPY QIFS2,IFS1044  Stopped copying file because of error .
  // ---------------------------------------------------------

  msg = AppMsg_new(cMSG_ID_OK);

  dou '1';

    //Get CCSIDs of FROM and TO file
    if (stat(i_fromPath: %addr(st_stat_from)) = RC_ERROR);
      clear IFS1044;
      IFS10441 = f_errno();
      IFS10442 = f_strerror(f_errno());
      msg = AppMsg_newEscape('IFS1044': IFS1044);
      leave;
    endif;

    if (stat(i_toPath: %addr(st_stat_to)) = RC_ERROR);
      if (f_errno() <> ENOENT_C);
        clear IFS1044;
        IFS10441 = f_errno();
        IFS10442 = f_strerror(f_errno());
        msg = AppMsg_newEscape('IFS1044': IFS1044);
        leave;
      endif;
      st_stat_to.ccsid = i_toCcsid;
      toOptions = O_CREAT + O_EXCL;
    else;
      toOptions = O_APPEND;
    endif;

    //Initialize code conversion
    if (st_stat_from.ccsid <> st_stat_to.ccsid);
      hIconv = Iconv_initialize(st_stat_from.ccsid: st_stat_to.ccsid);
      isCodeConversion = cTrue;
    else;
      isCodeConversion = cFalse;
    endif;

    monitor;

      //Open files
      hFrom = open(i_fromPath: O_SHARE_RDONLY + O_RDONLY);
      hTo   = open(i_toPath  : O_SHARE_RDONLY + O_WRONLY + toOptions);

      //Read input data, convert it to target CCSID and append data
      //to target file.
      byteRead = read(hFrom: %addr(inBuffer): %size(inBuffer));
      dow (byteRead > 0);

        //Convert input data to target CCSID
        if (isCodeConversion);
          inBufSize  = byteRead;
          outBufSize = %size(outBuffer);
          pInBuffer  = %addr(inBuffer );
          pOutBuffer = %addr(outBuffer);
          if (iconv(hIconv: pInBuffer : inBufSize
                          : pOutBuffer: outBufSize) = cICONV_ERROR);
            clear IFS1044;
            IFS10441 = f_errno();
            IFS10442 = f_strerror(f_errno());
            msg = AppMsg_newEscape('IFS1044': IFS1044);
            leave;
          endif;
          outBufSize = %size(outBuffer) - outBufSize;
          byteWrite = write(hTo: %addr(outBuffer): outBufSize);
          byteRead  = outBufSize;
        else;
          byteWrite = write(hTo: %addr(inBuffer): byteRead);
        endif;

        select;
        when (byteWrite = RC_ERROR);
          clear IFS1044;
          IFS10441 = f_errno();
          IFS10442 = f_strerror(f_errno());
          msg = AppMsg_newEscape('IFS1044': IFS1044);
          leave;
        when (byteWrite <> byteRead);
          clear IFS1043;
          IFS10431 = byteRead;
          IFS10432 = byteWrite;
          msg = AppMsg_newEscape('IFS1043': IFS1043);
          leave;
        endsl;

        //Read next chunk of data
        byteRead = read(hFrom: %addr(inBuffer): %size(inBuffer));
        select;
        when (byteRead = RC_ERROR);
          clear IFS1044;
          IFS10441 = f_errno();
          IFS10442 = f_strerror(f_errno());
          msg = AppMsg_newEscape('IFS1044': IFS1044);
          leave;
        when (byteRead = 0);
          isCopied = cTrue;
        endsl;
      enddo;

      //Close files
      callp(E) close(hFrom);
      callp(E) close(hTo);
    on-error;
      clear IFS1044;
      IFS10441 = f_errno();
      IFS10442 = f_strerror(f_errno());
      msg = AppMsg_newEscape('IFS1044': IFS1044);
      isCopied = cFalse;
    endmon;

    //Terminate code conversion
    if (isCodeConversion);
      Iconv_terminate(hIconv);
      isCodeConversion = cFalse;
    endif;

  enddo;

  o_msg = msg;

  return isCopied;

//
END-PROC;
//
//=========================================================================
//  *** private ***
//  Compares the given buffers with each other.
//=========================================================================
DCL-PROC compareBuffers;
  //
  DCL-PI *N INT(10);
    i_pBuffer1 POINTER CONST;
    i_pBuffer2 POINTER CONST;
    i_size     INT(10) CONST;
  END-PI;
  //
  //  Return value
  DCL-S rc INT(10) INZ(cIFS_ERROR);
  //
  //  Helper fields
  // ---------------------------------------------------------

  if (memcmp(i_pBuffer1: i_pBuffer2: i_size) <> 0);
    rc = cIFS_ERROR;
  else;
    rc = cIFS_OK;
  endif;

  return rc;

//
END-PROC;
//
