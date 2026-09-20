     *=====================================================================*                 RADDAT
     *  IFS2R02    - Tools/400: Stream File and Directory - Directory      *                 RADDAT
     *=====================================================================*                 RADDAT
     *  Author  :  Thomas Raddatz                                          *                 RADDAT
     *  Date    :  03.02.2009                                              *                 RADDAT
     *  E-mail  :  thomas.raddatz@Tools400.de                              *                 RADDAT
     *  Homepage:  www.tools400.de                                         *                 RADDAT
     *=====================================================================*                 RADDAT
     *                                                                     *                 RADDAT
     *  This software is free software, you can redistribute it and/or     *                 RADDAT
     *  modify it under the terms of the GNU General Public License (GPL)  *                 RADDAT
     *  as published by the Free Software Foundation.                      *                 RADDAT
     *                                                                     *                 RADDAT
     *  See GNU General Public License for details.                        *                 RADDAT
     *          http://www.opensource.org                                  *                 RADDAT
     *          http://www.opensource.org/licenses/gpl-license.html        *                 RADDAT
     *                                                                     *                 RADDAT
     *=====================================================================*                 RADDAT
     *  History:                                                           *                 RADDAT
     *                                                                     *                 RADDAT
     *  Datum       Name          Änderung                                 *                 RADDAT
     *  ----------  ------------  ---------------------------------------  *                 RADDAT
     *                                                                     *                 RADDAT
     * =================================================================== *                 RADDAT
     * >>PRE-COMPILER<<                                                    *                 RADDAT
     *   >>CRTCMD<< CRTRPGMOD    MODULE(&LI/&OB) +                         *                 RADDAT
     *                           SRCFILE(&SL/&SF) +                        *                 RADDAT
     *                           SRCMBR(&SM);                              *                 RADDAT
     *                                                                     *                 RADDAT
     *   >>COMPILE<<                                                       *                 RADDAT
     *     >>PARM<< DBGVIEW(*LIST);                                        *                 RADDAT
     *     >>PARM<< TRUNCNBR(*NO );                                        *                 RADDAT
     *     >>PARM<< TGTRLS(V6R1M0);                                        *                 RADDAT
     *   >>END-COMPILE<<                                                   *                 RADDAT
     *                                                                     *                 RADDAT
     *   >>EXECUTE<<                                                       *                 RADDAT
     *                                                                     *                 RADDAT
     * >>END-PRE-COMPILER<<                                                *                 RADDAT
     * =================================================================== *                 RADDAT
     H NOMAIN                                                                                 RADDAT
CPY  /COPY QIFS2,H_SPEC                                                                     RADDAT
     * =================================================================== *                 RADDAT
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  Exported prototypes                                                                  RADDAT
     * ------------------------------------                                                  RADDAT
CPY  /COPY QIFS2,PIFS2                                                                      RADDAT
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  Imported prototypes                                                                  RADDAT
     * ------------------------------------                                                  RADDAT
CPY  /COPY QIFS2,CEELIB                          CEE APIs                                   RADDAT
CPY  /COPY QIFS2,PIFS2R04                        App.Msg                                    RADDAT
CPY  /COPY QIFS2,PIFS2R05                        Application                                RADDAT
CPY  /COPY QIFS2,PIFS2R99                        Miscellaneous                              RADDAT
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  Private prototypes                                                                   RADDAT
     * ------------------------------------                                                  RADDAT
     *                                                                                       RADDAT
     *  Deletes all entries of a given directory and its subdirectories.                     RADDAT
     D clearDirectory...                                                                      RADDAT
     D                 PR              N                                                      RADDAT
     D                                     extproc('clearDirectory')                          RADDAT
     D  i_level                      10I 0 const                                              RADDAT
     D  i_directory                        const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)
     D  i_entry                            const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)
     D  i_type                             const  like(ifs_type_t    )                        RADDAT
     D  i_pUsrDta                      *   const                                              RADDAT
     D  o_msg                                     like(msg_t         )                        RADDAT
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  Type definitions                                                                     RADDAT
     * ------------------------------------                                                  RADDAT
CPY  /COPY QIFS2,TYPES                                                                      RADDAT
     *                                                                                       RADDAT
     *  'clearDirectory' user data                                                           RADDAT
     D clrDirUsrDta_t  DS                  qualified               based(pDummy)              RADDAT
     D  options                      10I 0                                                    RADDAT
     D  numE                         10I 0                                                    RADDAT
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  Global constants                                                                     RADDAT
     * ------------------------------------                                                  RADDAT
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  Global fields                                                                        RADDAT
     * ------------------------------------                                                  RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Returns cTrue if the specified directory exists, else cFalse.                        RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_directory   - The name of a given directory.                                      RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   doesExist     - Returns cTrue if the directory exists, else cFalse.                 RADDAT
     *=========================================================================              RADDAT
    P ifsDirectory_exist...                                                                  RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsDirectory_exist...                                                                  RADDAT
     D                 PI              N                                                      RADDAT
     D i_directory                         const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D doesExist       S               N   inz(cFalse)                                        RADDAT
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_msg           C                   const(2)                                           RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D msg             DS                  likeds(msg_t    ) inz                              RADDAT
     *                                                                                       RADDAT
     *  stat() result data structure                                                         RADDAT
     D st_stat         DS                  likeds(st_stat_t) inz                              RADDAT
     *                                                                                       RADDAT
CPY  /COPY QIFS2,IFS1034                         Failed to retrieve directory information   RADDAT
     * ---------------------------------------------------------                             RADDAT
      /free
                                                                                            //RADDAT
         f_clrErrno();                                                                      //RADDAT
                                                                                            //RADDAT
         //If the object could not be found, ...                                           //RADDAT
 B01     if (stat(ifsPath_fixSyntax(i_directory): %addr(st_stat)) = RC_ERROR);              //RADDAT
            //... check error code to ensure that it is 3025 "no such file or directory"   //RADDAT
 B02        if (f_errno() <> ENOENT_C);                                                     //RADDAT
               clear IFS1034;                                                               //RADDAT
               IFS10341 = i_directory;                                                      //RADDAT
               IFS10342 = f_errno();                                                        //RADDAT
               IFS10343 = f_strerror(f_errno());                                            //RADDAT
               Application_killWithMsg(AppMsg_newEscape('IFS1034': IFS1034));               //RADDAT
 E02        endif;                                                                          //RADDAT
            return cFalse;                                                                  //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         //Ensure that the object is a directory and not a file.                           //RADDAT
 B01     if (not STAT_isDirectory(st_stat));                                                //RADDAT
            return cFalse;                                                                  //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         return cTrue;                                                                      //RADDAT
                                                                                            //RADDAT
      /end-free
     *                                                                                       RADDAT
    P ifsDirectory_exist...                                                                  RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Creates a new IFS directory.                                                         RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_directory   - Directory to create.                                                RADDAT
     *   i_options     - Options:                                                            RADDAT
     *                   cIFS_MKDIR_DFT           Default settings.                          RADDAT
     *                   cIFS_MKDIR_SUBDIR        Create directories recursively             RADDAT
     *   i_auth        - Authority. See: ifsFile_open()                                      RADDAT
     *   o_msg         - Error message.                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   rc            - Returns cIFS_OK on success, else cIFS_ERROR.                        RADDAT
     *=========================================================================              RADDAT
    P ifsDirectory_create...                                                                 RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsDirectory_create...                                                                 RADDAT
     D                 PI            10I 0                                                    RADDAT
     D  i_directory                        const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)
     D  i_options                    10I 0 const  options(*nopass: *omit)                     RADDAT
     D  i_auth                       10I 0 const  options(*nopass: *omit)                     RADDAT
     D  o_msg                                     like(msg_t      )                           RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D rc              S             10I 0 inz(cIFS_ERROR)                                    RADDAT
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_options       C                   const(2)                                           RADDAT
     D p_auth          C                   const(3)                                           RADDAT
     D p_msg           C                   const(4)                                           RADDAT
     *                                                                                       RADDAT
     *  Fields for optional parameters                                                       RADDAT
     D options         S                   like(i_options  ) inz                              RADDAT
     D auth            S                   like(i_auth     ) inz                              RADDAT
     D msg             DS                  likeds(msg_t    ) inz                              RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D x               S             10I 0 inz                                                RADDAT
     D y               S             10I 0 inz                                                RADDAT
     D directory       S                   like(ifs_path_t ) inz                              RADDAT
     D homeDir         S                   like(ifs_path_t ) inz                              RADDAT
     D newDir          S                   like(ifs_path_t ) inz                              RADDAT
     D tmpAuth         S                   like(auth       ) inz                              RADDAT
     *                                                                                       RADDAT
     *  stat() result data structure                                                         RADDAT
     D st_stat         DS                  likeds(st_stat_t) inz                              RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D isRecursion     S               N   inz(cFalse)                                        RADDAT
     *                                                                                       RADDAT
CPY  /COPY QIFS2,IFS1024                         Invalid path name.                         RADDAT
CPY  /COPY QIFS2,IFS1025                         Failed to retrieve permissions and ...     RADDAT
CPY  /COPY QIFS2,IFS1026                         Failed to create directory '&1'.           RADDAT
CPY  /COPY QIFS2,IFS1027                         Could not set permissions for directory ...RADDAT
CPY  /COPY QIFS2,IFS1032                         Directory '&1' already exists.             RADDAT
CPY  /COPY QIFS2,IFS1035                         Failed to create directory '&1' ...        RADDAT
     * ---------------------------------------------------------                             RADDAT
      /free
                                                                                            //RADDAT
         //Process optional parameters ...                                                 //RADDAT
         //... i_options                                                                   //RADDAT
 B01     if (%parms() >= p_options and %addr(i_options) <> *NULL);                          //RADDAT
            options = i_options;                                                            //RADDAT
 X01     else;                                                                              //RADDAT
            options = cIFS_MKDIR_DFT;                                                       //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         //... i_auth                                                                      //RADDAT
 B01     if (%parms() >= p_auth and %addr(i_auth) <> *NULL);                                //RADDAT
            auth = i_auth;                                                                  //RADDAT
 X01     else;                                                                              //RADDAT
            auth = -1;                                                                      //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         //Clear error message                                                             //RADDAT
         msg = AppMsg_new(cMsg_ID_OK);                                                      //RADDAT
                                                                                            //RADDAT
 B01     dou '1';                                                                           //RADDAT
                                                                                            //RADDAT
            //Check whether the path has to be created recursively or not                  //RADDAT
            isRecursion = f_isBitOn(cIFS_MKDIR_SUBDIR: options);                            //RADDAT
                                                                                            //RADDAT
            //Fix path (slashes)                                                           //RADDAT
            directory = ifsDirectory_fixSyntax(i_directory);                                //RADDAT
                                                                                            //RADDAT
            //Ensure that the user did not specifiy the                                    //RADDAT
            //root directory or an empty string.                                           //RADDAT
 B02        if (directory = cSLASH or %len(%trim(directory)) = 0);                          //RADDAT
               clear IFS1024;                                                               //RADDAT
               IFS10241 = i_directory;                                                      //RADDAT
               msg = AppMsg_newEscape('IFS1024': IFS1024);                                  //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            //Ensure that the directory does not already exist                             //RADDAT
 B02        if (ifsDirectory_exist(directory));                                             //RADDAT
               clear IFS1032;                                                               //RADDAT
               IFS10321 = i_directory;                                                      //RADDAT
               msg = AppMsg_newEscape('IFS1032': IFS1032);                                  //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            //Ensure that a file with the same name does not already exist                 //RADDAT
 B02        if (ifsFile_exist(directory));                                                  //RADDAT
               clear IFS1035;                                                               //RADDAT
               IFS10351 = i_directory;                                                      //RADDAT
               msg = AppMsg_newEscape('IFS1035': IFS1035);                                  //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            //Create directory:                                                            //RADDAT
 B02        if (f_startsWith(cSLASH: directory));                                           //RADDAT
               x = %scan(cSLASH: directory: 2);                                             //RADDAT
               homeDir = cSLASH;                                                            //RADDAT
 X02        else;                                                                           //RADDAT
               x = %scan(cSLASH: directory: 1);                                             //RADDAT
               homeDir = '.';                                                               //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
 B02        dow (x <> 0);                                                                   //RADDAT
                                                                                            //RADDAT
               newDir = %subst(directory: 1: x);                                            //RADDAT
                                                                                            //RADDAT
 B03           if ((isRecursion or x = %len(directory))
                    and not ifsDirectory_exist(newDir));                                    //RADDAT
                                                                                            //RADDAT
                  //Determine directory authorization                                      //RADDAT
 B04              if (auth < 0);                                                            //RADDAT
                     rc = stat(homeDir: %addr(st_stat));                                    //RADDAT
 B05                 if (rc = RC_ERROR);                                                    //RADDAT
                        clear IFS1025;                                                      //RADDAT
                        IFS10251 = homeDir;                                                 //RADDAT
                        IFS10252 = f_errno();                                               //RADDAT
                        IFS10253 = f_strerror(f_errno());                                   //RADDAT
                        msg = AppMsg_newEscape('IFS1025': IFS1025);                         //RADDAT
                        leave;                                                              //RADDAT
 E05                 endif;                                                                 //RADDAT
 X04              else;                                                                     //RADDAT
                     st_stat.mode = auth;                                                   //RADDAT
 E04              endif;                                                                    //RADDAT
                                                                                            //RADDAT
                  //Create directory                                                       //RADDAT
                  tmpAuth = %bitand(st_stat.mode: S_IRWXU + S_IRWXG + S_IRWXO);             //RADDAT
                  rc = mkdir(newDir: tmpAuth);                                              //RADDAT
                                                                                            //RADDAT
                  //If we got an error                                                     //RADDAT
 B04              if (rc = RC_ERROR);                                                       //RADDAT
                     //... then create error message                                       //RADDAT
                     clear IFS1026;                                                         //RADDAT
                     IFS10261 = %trim(newDir);                                              //RADDAT
                     IFS10262 = f_errno();                                                  //RADDAT
                     IFS10263 = f_strerror(f_errno());                                      //RADDAT
                     msg = AppMsg_newEscape('IFS1026': IFS1026);                            //RADDAT
                     leave;                                                                 //RADDAT
 E04              endif;                                                                    //RADDAT
                                                                                            //RADDAT
                  //Set bits for "effective user id", "effective group id" and             //RADDAT
                  //"restricted renames and unlinks"                                       //RADDAT
                  tmpAuth = %bitand(st_stat.mode: S_IRWXU + S_IRWXG + S_IRWXO +
                                                  S_ISUID + S_ISGID + S_ISVTX);             //RADDAT
                  rc = chmod(newDir: tmpAuth);                                              //RADDAT
                                                                                            //RADDAT
                  //If we got an error                                                     //RADDAT
 B04              if (rc = RC_ERROR);                                                       //RADDAT
                     //... then create error message                                       //RADDAT
                     clear IFS1027;                                                         //RADDAT
                     IFS10271 = %trim(newDir);                                              //RADDAT
                     IFS10272 = f_errno();                                                  //RADDAT
                     IFS10273 = f_strerror(f_errno());                                      //RADDAT
                     msg = AppMsg_newEscape('IFS1027': IFS1027);                            //RADDAT
                     leave;                                                                 //RADDAT
 E04              endif;                                                                    //RADDAT
                                                                                            //RADDAT
 E03           endif;                                                                       //RADDAT
                                                                                            //RADDAT
               homeDir = newDir;                                                            //RADDAT
                                                                                            //RADDAT
 B03           if (x < %len(directory));                                                    //RADDAT
                  x = %scan(cSLASH: directory: x+1);                                        //RADDAT
 X03           else;                                                                        //RADDAT
                  x = 0;                                                                    //RADDAT
 E03           endif;                                                                       //RADDAT
 E02        enddo;                                                                          //RADDAT
                                                                                            //RADDAT
            rc = 0;                                                                         //RADDAT
 E01     enddo;                                                                             //RADDAT
                                                                                            //RADDAT
         //Ensure that message has been correctly set                                      //RADDAT
         p_assert(msg.ID = cMsg_ID_OK or msg.type = cMsg_Escape);                           //RADDAT
                                                                                            //RADDAT
         //If the message parameter was passed ...                                         //RADDAT
 B01     if (%parms() >= p_msg);                                                            //RADDAT
            //... and not omitted                                                          //RADDAT
 B02        if (%addr(o_msg) <> *NULL);                                                     //RADDAT
               //Return back message                                                       //RADDAT
               o_msg = msg;                                                                 //RADDAT
 E02        endif;                                                                          //RADDAT
 X01     else;                                                                              //RADDAT
            //... else send message                                                        //RADDAT
 B02        if (msg.ID <> cMsg_ID_OK);                                                      //RADDAT
               f_sndPgmMsg(msg: cMsg_Prv);                                                  //RADDAT
 E02        endif;                                                                          //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         return rc;                                                                         //RADDAT
                                                                                            //RADDAT
      /end-free
     *                                                                                       RADDAT
    P ifsDirectory_create...                                                                 RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Deletes a given directory.                                                           RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_directory   - Directory to delete.                                                RADDAT
     *   i_options     - Options:                                                            RADDAT
     *                   cIFS_RMDIR_DFT           Default settings.                          RADDAT
     *                   cIFS_RMDIR_DELETE_SUB_DIRECTORIES Delete subdirectories.            RADDAT
     *   o_msg         - Error message.                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   rc            - Returns number of deleted files and directories                     RADDAT
     *                   on success, else cIFS_ERROR.                                        RADDAT
     *=========================================================================              RADDAT
    P ifsDirectory_remove...                                                                 RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsDirectory_remove...                                                                 RADDAT
     D                 PI            10I 0                                                    RADDAT
     D  i_directory                        const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)
     D  i_options                    10I 0 const  options(*nopass: *omit)                     RADDAT
     D  o_msg                                     like(msg_t      )                           RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D rc              S             10I 0 inz(cIFS_ERROR)                                    RADDAT
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_options       C                   const(2)                                           RADDAT
     D p_msg           C                   const(3)                                           RADDAT
     *                                                                                       RADDAT
     *  Fields for optional parameters                                                       RADDAT
     D options         S                   like(i_options  ) inz                              RADDAT
     D msg             DS                  likeds(msg_t    ) inz                              RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D subDirOptions   S             10I 0 inz                                                RADDAT
     D directory       S                   like(ifs_path_t ) inz                              RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D mustClearDirectory...                                                                  RADDAT
     D                 S               N   inz(cFalse)                                        RADDAT
     D tmpMsg          DS                  likeds(msg_t    ) inz                              RADDAT
     *                                                                                       RADDAT
     D usrDta          DS                  likeds(clrDirUsrDta_t ) inz                        RADDAT
     *                                                                                       RADDAT
CPY  /COPY QIFS2,IFS1024                         Invalid path name.                         RADDAT
CPY  /COPY QIFS2,IFS1031                         Failed to delete IFS directory '&1'.       RADDAT
     * ---------------------------------------------------------                             RADDAT
      /free
                                                                                            //RADDAT
         //Process optional parameters ...                                                 //RADDAT
         //... i_options                                                                   //RADDAT
 B01     if (%parms() >= p_options and %addr(i_options) <> *NULL);                          //RADDAT
            options = i_options;                                                            //RADDAT
 X01     else;                                                                              //RADDAT
            options = cIFS_RMDIR_DFT;                                                       //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         //Clear error message                                                             //RADDAT
         msg = AppMsg_new(cMsg_ID_OK);                                                      //RADDAT
                                                                                            //RADDAT
 B01     dou '1';                                                                           //RADDAT
                                                                                            //RADDAT
            //Fix path (slashes)                                                           //RADDAT
            directory = ifsDirectory_fixSyntax(i_directory);                                //RADDAT
                                                                                            //RADDAT
            //Check whether subdirectories must be deleted                                 //RADDAT
            mustClearDirectory =
               f_isBitOn(cIFS_RMDIR_DELETE_SUB_DIRECTORIES: options);                       //RADDAT
                                                                                            //RADDAT
            //Ensure that the user did not specifiy the                                    //RADDAT
            //root directory or an empty string.                                           //RADDAT
 B02        if (directory = cSLASH or %len(%trim(directory)) = 0);                          //RADDAT
               clear IFS1024;                                                               //RADDAT
               IFS10241 = i_directory;                                                      //RADDAT
               msg = AppMsg_newEscape('IFS1024': IFS1024);                                  //RADDAT
               rc = cIFS_ERROR;                                                             //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            //Remove directory entries                                                     //RADDAT
 B02        if (mustClearDirectory);                                                        //RADDAT
               subDirOptions = cIFS_READDIR_CB_NAME + cIFS_READDIR_POST_ORDER
                                                    + cIFS_READDIR_DIRECTORY
                                                    + cIFS_READDIR_FILE;                    //RADDAT
                                                                                            //RADDAT
               usrDta.numE    = 0;                                                          //RADDAT
               usrDta.options = options;                                                    //RADDAT
                                                                                            //RADDAT
 B03           if (ifsDirectory_read(directory
                                     : %paddr('clearDirectory')
                                     : subDirOptions
                                     : %addr(usrDta)
                                     : tmpMsg) = cIFS_ERROR);                               //RADDAT
                  msg = tmpMsg;                                                             //RADDAT
                  rc = cIFS_ERROR;                                                          //RADDAT
                  leave;                                                                    //RADDAT
 E03           endif;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            //Delete directory                                                             //RADDAT
 B02        if (rmDir(directory) <> 0);                                                     //RADDAT
               clear IFS1031;                                                               //RADDAT
               IFS10311 = directory;                                                        //RADDAT
               IFS10312 = f_errno();                                                        //RADDAT
               IFS10313 = f_strerror(f_errno());                                            //RADDAT
               msg = AppMsg_newEscape('IFS1031': IFS1031);                                  //RADDAT
               rc = cIFS_ERROR;                                                             //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            rc = usrDta.numE + 1;                                                           //RADDAT
 E01     enddo;                                                                             //RADDAT
                                                                                            //RADDAT
         //Ensure that message has been correctly set                                      //RADDAT
         p_assert(msg.ID = cMsg_ID_OK or msg.type = cMsg_Escape);                           //RADDAT
                                                                                            //RADDAT
         //If the message parameter was passed ...                                         //RADDAT
 B01     if (%parms() >= p_msg);                                                            //RADDAT
            //... and not omitted                                                          //RADDAT
 B02        if (%addr(o_msg) <> *NULL);                                                     //RADDAT
               //Return back message                                                       //RADDAT
               o_msg = msg;                                                                 //RADDAT
 E02        endif;                                                                          //RADDAT
 X01     else;                                                                              //RADDAT
            //... else send message                                                        //RADDAT
 B02        if (msg.ID <> cMsg_ID_OK);                                                      //RADDAT
               f_sndPgmMsg(msg: cMsg_Prv);                                                  //RADDAT
 E02        endif;                                                                          //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         return rc;                                                                         //RADDAT
                                                                                            //RADDAT
      /end-free
     *                                                                                       RADDAT
    P ifsDirectory_remove...                                                                 RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Renames a given directory.                                                           RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_fromDirectory - Name of the directory that shall be renamed.                      RADDAT
     *   i_toDirectory   - New name of the directory.                                        RADDAT
     *   o_msg           - Error message.                                                    RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   rc            - Returns cIFS_OK on success, else CIFS_ERROR.                        RADDAT
     *=========================================================================              RADDAT
    P ifsDirectory_rename...                                                                 RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsDirectory_rename...                                                                 RADDAT
     D                 PI            10I 0                                                    RADDAT
     D i_fromDirectory...                                                                     RADDAT
     D                                     const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)
     D i_toDirectory                       const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D rc              S             10I 0 inz                                                RADDAT
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_msg           C                   const(3)                                           RADDAT
     *                                                                                       RADDAT
     *  Fields for optional parameters                                                       RADDAT
     D msg             DS                  likeds(msg_t    ) inz                              RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D tmpRC           S             10I 0 inz                                                RADDAT
     D toPath          S                   like(ifs_path_t ) inz                              RADDAT
     *                                                                                       RADDAT
CPY  /COPY QIFS2,IFS1039                         Failed to rename directory '&1' to '&2'.   RADDAT
CPY  /COPY QIFS2,IFS1011                         Directory '&1' does not exist.             RADDAT
CPY  /COPY QIFS2,IFS1032                         Directory '&1' already exits.              RADDAT
CPY  /COPY QIFS2,IFS1038                         Directory name '&1' contains invalid ...   RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         msg = AppMsg_new(cMsg_ID_OK);                                                      //RADDAT
                                                                                            //RADDAT
 B01     dou '1';                                                                           //RADDAT
                                                                                            //RADDAT
            //If the file does not exist, ...                                              //RADDAT
 B02        if (not ifsDirectory_exist(i_fromDirectory));                                   //RADDAT
               //... then create an error message                                          //RADDAT
               clear IFS1011;                                                               //RADDAT
               IFS10111 = i_fromDirectory;                                                  //RADDAT
               msg = AppMsg_newEscape('IFS1011': IFS1011);                                  //RADDAT
               rc = cIFS_ERROR;                                                             //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            //If the target file name contains a directory, ...                            //RADDAT
 B02        if (not ifsPath_isNameOnly(i_toDirectory));                                     //RADDAT
               //... then create error message                                             //RADDAT
               rc = RC_ERROR;                                                               //RADDAT
               clear IFS1038;                                                               //RADDAT
               IFS10381 = %trim(i_toDirectory);                                             //RADDAT
               msg = AppMsg_newEscape('IFS1038': IFS1038);                                  //RADDAT
               rc = cIFS_ERROR;                                                             //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            //Compute path of target file                                                  //RADDAT
            toPath = ifsPath_fixSyntax(
                        ifsPath_getDirectory(i_fromDirectory) + i_toDirectory);             //RADDAT
                                                                                            //RADDAT
            //If the target file does already exist, ...                                   //RADDAT
 B02        if (ifsFile_exist(toPath));                                                     //RADDAT
               //... then create error message                                             //RADDAT
               clear IFS1032;                                                               //RADDAT
               IFS10321 = toPath;                                                           //RADDAT
               msg = AppMsg_newEscape('IFS1032': IFS1032);                                  //RADDAT
               rc = cIFS_ERROR;                                                             //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            //Rename stream file                                                           //RADDAT
            tmpRC = Qp0lRenameKeep(ifsPath_fixSyntax(i_fromDirectory): toPath);             //RADDAT
                                                                                            //RADDAT
            //If we got an error, ...                                                      //RADDAT
 B02        if (tmpRC = RC_ERROR);                                                          //RADDAT
            //... then create error message                                                //RADDAT
               clear IFS1039;                                                               //RADDAT
               IFS10391 = i_fromDirectory;                                                  //RADDAT
               IFS10392 = i_toDirectory;                                                    //RADDAT
               IFS10393 = f_errno();                                                        //RADDAT
               IFS10394 = f_strerror(f_errno());                                            //RADDAT
               msg = AppMsg_newEscape('IFS1039': IFS1039);                                  //RADDAT
               rc = cIFS_ERROR;                                                             //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            rc = cIFS_OK;                                                                   //RADDAT
 E01     enddo;                                                                             //RADDAT
                                                                                            //RADDAT
         //Ensure that message has been correctly set                                      //RADDAT
         p_assert(msg.ID = cMsg_ID_OK or msg.type = cMsg_Escape);                           //RADDAT
                                                                                            //RADDAT
         //If the message parameter was passed ...                                         //RADDAT
 B01     if (%parms() >= p_msg);                                                            //RADDAT
            //... and not omitted                                                          //RADDAT
 B02        if (%addr(o_msg) <> *NULL);                                                     //RADDAT
               //Return back message                                                       //RADDAT
               o_msg = msg;                                                                 //RADDAT
 E02        endif;                                                                          //RADDAT
 X01     else;                                                                              //RADDAT
            //... else send message                                                        //RADDAT
 B02        if (msg.ID <> cMsg_ID_OK);                                                      //RADDAT
               f_sndPgmMsg(msg: cMsg_Prv);                                                  //RADDAT
 E02        endif;                                                                          //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         return rc;                                                                         //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P ifsDirectory_rename...                                                                 RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Reads the entries of a given directory.                                              RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_path        - The name of an IFS directory.                                       RADDAT
     *                   Wildcard characters are: '*' and '?'.                               RADDAT
     *   i_pCallback   - Procdure pointer of callback procedure.                             RADDAT
     *                   The callback procedure is called for each entry                     RADDAT
     *                   that matches the search criteria.                                   RADDAT
     *   i_options     - Options:                                   1) = Default settings.   RADDAT
     *                   cIFS_READDIR_DFT             default settings.                      RADDAT
     *                   cIFS_READDIR_FILE            list files.                        1)  RADDAT
     *                   cIFS_READDIR_DIRECTORY       list directories.                  1)  RADDAT
     *                   cIFS_READDIR_ALL             list all directory entries.            RADDAT
     *                   cIFS_READDIR_CB_NAME         pass entry name to callback.       1)  RADDAT
     *                   cIFS_READDIR_CB_DIRENT       pass dirent structure to callback.     RADDAT
     *                   cIFS_READDIR_SUBDIRECTORY    process sub-directories.               RADDAT
     *                   cIFS_READDIR_PRE_ORDER       first callback, then subdirectory. 1)  RADDAT
     *                   cIFS_READDIR_POST_ORDER      first subdirectory, then callback.     RADDAT
     *                   cIFS_READDIR_RESOLVE_SYMLNK  resolve symbolic links.                RADDAT
     *   i_pUserData   - Pointer to user data.                                               RADDAT
     *   o_msg         - Error message.                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   rc            - Returns the number of entries found on success, else -1.            RADDAT
     * ------------------------------------------------------------------------              RADDAT
     *  Callback:      ifsDirectory_read_Path      (cIFS_READDIR_CB_NAME)                    RADDAT
     *                                                                                       RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_level       - Nesting level. The first directory is level 1.                      RADDAT
     *   i_directory   - Path of the current directory.                                      RADDAT
     *   i_entry       - Name of the current directory entry.                                RADDAT
     *   i_type        - Type of the current directory entry.                                RADDAT
     *   o_msg         - Error message.                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   doContinue    - Returns cIFS_CONTINUE on succes, else cIFS_CANCEL;                  RADDAT
     *                                                                                       RADDAT
     * ------------------------------------------------------------------------              RADDAT
     *  Callback:      ifsDirectory_read_Dirent    (cIFS_READDIR_CB_DIRENT)                  RADDAT
     *                                                                                       RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_level       - Nesting level. The first directory is level 1.                      RADDAT
     *   i_directory   - Path of the current directory.                                      RADDAT
     *   i_dirent      - Structure dirent_t of the current directory entry.                  RADDAT
     *   i_type        - Type of the current directory entry.                                RADDAT
     *   o_msg         - Error message.                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   doContinue    - Returns cIFS_CONTINUE on succes, else cIFS_CANCEL;                  RADDAT
     *                                                                                       RADDAT
     * ------------------------------------------------------------------------              RADDAT
     *  Known directory entry types:                                                         RADDAT
     *   cIFS_DIRENT_TYPE_FILE          - File.                                              RADDAT
     *   cIFS_DIRENT_TYPE_DOCUMENT      - Document, member of folder in QDLS.                RADDAT
     *   cIFS_DIRENT_TYPE_DIRECTORY     - Directory.                                         RADDAT
     *   cIFS_DIRENT_TYPE_FOLDER        - Folder, contained in QDLS.                         RADDAT
     *   cIFS_DIRENT_TYPE_SYMBOLIC_LINK - Symbolic link.                                     RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
    P ifsDirectory_read...                                                                   RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsDirectory_read...                                                                   RADDAT
     D                 PI            10I 0                                                    RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)
     D i_pCallback                     *   const  procptr                                     RADDAT
     D i_options                     10I 0 const  options(*nopass: *omit)                     RADDAT
     D i_pUserData                     *   const  options(*nopass: *omit)                     RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D numEntries      S             10I 0 inz                                                RADDAT
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_options       C                   const(3)                                           RADDAT
     D p_pUserData     C                   const(4)                                           RADDAT
     D p_msg           C                   const(5)                                           RADDAT
     *                                                                                       RADDAT
     *  Fields for optional parameters                                                       RADDAT
     D pUserData       S                   like(i_pUserData) inz                              RADDAT
     D options         S                   like(i_options  ) inz                              RADDAT
     D msg             DS                  likeds(msg_t    ) inz                              RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D doAllEntries    S               N                     inz(cFalse)                      RADDAT
     D isPreOrder      S               N                     inz(cFalse)                      RADDAT
     D isPostOrder     S               N                     inz(cFalse)                      RADDAT
     D isUserError     S               N                     inz(cFalse)                      RADDAT
     D doResolveSymLinks...                                                                   RADDAT
     D                 S               N                     inz(cFalse)                      RADDAT
     D path            S                   like(i_path     ) inz                              RADDAT
     D directory       S                   like(i_path     ) inz                              RADDAT
     D pattern         S                   like(i_path     ) inz                              RADDAT
     D entry           S                   like(i_path     ) inz                              RADDAT
     D numSubEntries   S                   like(numEntries ) inz                              RADDAT
     D pDIR            S               *                     inz                              RADDAT
     D level           S             10I 0                   inz   static                     RADDAT
     D dirEnt          DS                  likeds(dirent_t ) based(pDirEnt)                   RADDAT
     D st_stat         DS                  likeds(st_stat_t) inz                              RADDAT
     *                                                                                       RADDAT
     *  Callback Procedures                                                                  RADDAT
     *                                                                                       RADDAT
     D ifsDirectory_read_Path...                                                              RADDAT
     D                 PR              N   extproc(i_pCallback)                               RADDAT
     D  i_level                      10I 0 const                                              RADDAT
     D  i_directory                        const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)
     D  i_file                             const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)
     D  i_type                             const  like(ifs_type_t    )                        RADDAT
     D  i_pUserData                    *   const                                              RADDAT
     D  o_msg                                     like(msg_t         )                        RADDAT
     *                                                                                       RADDAT
     D ifsDirectory_read_Dirent...                                                            RADDAT
     D                 PR              N   extproc(i_pCallback)                               RADDAT
     D  i_level                      10I 0 const                                              RADDAT
     D  i_directory                        const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)
     D  i_dirent                           const  likeds(dirent_t    )                        RADDAT
     D  i_type                             const  like(ifs_type_t    )                        RADDAT
     D  i_pUserData                    *   const                                              RADDAT
     D  o_msg                                     like(msg_t         )                        RADDAT
     *                                                                                       RADDAT
CPY  /COPY QIFS2,IFS1017                         Entry has not been read from directory ... RADDAT
CPY  /COPY QIFS2,IFS1018                         Attributes of object '&1' not retrieved.   RADDAT
CPY  /COPY QIFS2,IFS1019                         Directory '&1' not opened.                 RADDAT
CPY  /COPY QIFS2,IFS1020                         Directory '&1' not closed.                 RADDAT
CPY  /COPY QIFS2,IFS1050                         Attributes of symbolic link '&1' not ...   RADDAT
     * ---------------------------------------------------------                             RADDAT
      /free
                                                                                            //RADDAT
         //Process optional parameters ...                                                 //RADDAT
         //... i_options                                                                   //RADDAT
 B01     if (%parms() >= p_options and %addr(i_options) <> *NULL);                          //RADDAT
            options = i_options;                                                            //RADDAT
 X01     else;                                                                              //RADDAT
            options = cIFS_READDIR_DFT;                                                     //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         //... i_pUserData                                                                 //RADDAT
 B01     if (%parms() >= p_pUserData and %addr(i_pUserData) <> *NULL);                      //RADDAT
            pUserData = i_pUserData;                                                        //RADDAT
 X01     else;                                                                              //RADDAT
            pUserData = *NULL;                                                              //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         //Clear error message                                                             //RADDAT
         msg = AppMsg_new(cMsg_ID_OK);                                                      //RADDAT
                                                                                            //RADDAT
         //Check and complete default settings                                             //RADDAT
         //     cIFS_READDIR_FILE                                                          //RADDAT
         //     cIFS_READDIR_DIRECTORY                                                     //RADDAT
         //     cIFS_READDIR_CB_NAME                                                       //RADDAT
         //     cIFS_READDIR_PRE_ORDER                                                     //RADDAT
 B01     if (not f_isBitOn(cIFS_READDIR_FILE: options) and
             not f_isBitOn(cIFS_READDIR_DIRECTORY: options));                               //RADDAT
            options = %bitor(cIFS_READDIR_FILE
                             : cIFS_READDIR_DIRECTORY
                             : options);                                                    //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
 B01     if (not f_isBitOn(cIFS_READDIR_CB_NAME: options) and
             not f_isBitOn(cIFS_READDIR_CB_DIRENT: options));                               //RADDAT
            options = %bitor(cIFS_READDIR_CB_NAME: options);                                //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         isPreOrder  = f_isBitOn(cIFS_READDIR_PRE_ORDER: options);                          //RADDAT
         isPostOrder = f_isBitOn(cIFS_READDIR_POST_ORDER: options);                         //RADDAT
                                                                                            //RADDAT
 B01     if (not isPreOrder and not isPostOrder);                                           //RADDAT
            options = %bitor(cIFS_READDIR_PRE_ORDER: options);                              //RADDAT
            isPreOrder = cTrue;                                                             //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         doResolveSymLinks = f_isBitOn(cIFS_READDIR_RESOLVE_SYMLNK: options);               //RADDAT
                                                                                            //RADDAT
         //Increase call level                                                             //RADDAT
         level = level + 1;                                                                 //RADDAT
                                                                                            //RADDAT
         //Fix path (slashes)                                                              //RADDAT
         path = ifsPath_fixSyntax(i_path);                                                  //RADDAT
                                                                                            //RADDAT
         //Add "*.*" if path does not contain entry mask                                   //RADDAT
 B01     if (f_endsWith(cSLASH: path));                                                     //RADDAT
            path = path + '*.*';                                                            //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         directory = ifsPath_getDirectory(path);                                            //RADDAT
         pattern   = ifsPath_getName(path);                                                 //RADDAT
                                                                                            //RADDAT
         doAllEntries = f_isBitOn(cIFS_READDIR_ALL: options);                               //RADDAT
                                                                                            //RADDAT
         //Open directory                                                                  //RADDAT
         pDIR = opendir(directory);                                                         //RADDAT
 B01     if (pDIR = *NULL);                                                                 //RADDAT
            //... create error message                                                     //RADDAT
            clear IFS1019;                                                                  //RADDAT
            IFS10191 = %trimR(directory);                                                   //RADDAT
            IFS10192 = f_errno();                                                           //RADDAT
            IFS10193 = f_strerror(f_errno());                                               //RADDAT
            msg = AppMsg_newEscape('IFS1019': IFS1019);                                     //RADDAT
 X01     else;                                                                              //RADDAT
                                                                                            //RADDAT
            //Spin through directory entries                                               //RADDAT
            pDirEnt = *NULL;                                                                //RADDAT
 B02        dou (pDirEnt = *NULL);                                                          //RADDAT
                                                                                            //RADDAT
               //Process directory entry                                                   //RADDAT
 B03           if (pDirEnt <> *NULL);                                                       //RADDAT
                                                                                            //RADDAT
                  //Get entry name                                                         //RADDAT
                  entry = %subst(dirent.d_name: 1: dirent.d_namelen);                       //RADDAT
                                                                                            //RADDAT
                  //Ignore '.' and '..' directory entries                                  //RADDAT
 B04              if ((entry <> '.' and entry <> '..') or doAllEntries);                    //RADDAT
                                                                                            //RADDAT
                     //Get file information                                                //RADDAT
 B05                 if (lstat(directory + entry: %addr(st_stat)) = RC_ERROR);              //RADDAT
 B06                    if   f_errno() = ENOENT_C;   //No such path or directory           //RADDAT
                           entry = '';                                                      //RADDAT
 X06                    else;                                                               //RADDAT
                           clear IFS1018;                                                   //RADDAT
                           IFS10181 = directory + entry;                                    //RADDAT
                           IFS10182 = f_errno();                                            //RADDAT
                           IFS10183 = f_strerror(f_errno());                                //RADDAT
                           msg = AppMsg_newEscape('IFS1018': IFS1018);                      //RADDAT
                           leave;                                                           //RADDAT
 E06                    endif;                                                              //RADDAT
 E05                 endif;                                                                 //RADDAT
                                                                                            //RADDAT
                     //Resolve symbolic links                                              //RADDAT
 B05                 if (entry <> '' and
                         STAT_isSymbolicLink(st_stat) and doResolveSymLinks);               //RADDAT
 B06                    if (stat(directory + entry: %addr(st_stat)) = RC_ERROR);            //RADDAT
 B07                       if   f_errno() = ENOENT_C;   //No such path or directory        //RADDAT
                              entry = '';                                                   //RADDAT
 X07                       else;                                                            //RADDAT
                              clear IFS1050;                                                //RADDAT
                              IFS10501 = directory + entry;                                 //RADDAT
                              IFS10502 = f_errno();                                         //RADDAT
                              IFS10503 = f_strerror(f_errno());                             //RADDAT
                              msg = AppMsg_newEscape('IFS1050': IFS1050);                   //RADDAT
                              leave;                                                        //RADDAT
 E07                       endif;                                                           //RADDAT
 E06                    endif;                                                              //RADDAT
 E05                 endif;                                                                 //RADDAT
                                                                                            //RADDAT
                     //Process sub-directory                                               //RADDAT
                     //(post-order: first subdirectory, then calback                       //RADDAT
 B05                 if (entry <> '' and isPostOrder);                                      //RADDAT
                        exsr processSubDirectory;                                           //RADDAT
 B06                    if (numSubEntries = RC_ERROR);                                      //RADDAT
                           leave;                                                           //RADDAT
 E06                    endif;                                                              //RADDAT
 E05                 endif;                                                                 //RADDAT
                                                                                            //RADDAT
                     //If the entry matches the pattern ...                                //RADDAT
 B05                 if (entry <> '' and
                         i_pCallback <> *NULL and
                         File_matchesPattern(entry: pattern));                              //RADDAT
                                                                                            //RADDAT
                        //... and the filter criteria, ...                                 //RADDAT
 B06                    if (doAllEntries or
                            (STAT_isFile(st_stat) and
                             f_isBitOn(cIFS_READDIR_FILE: options)) or
                            (STAT_isDirectory(st_stat ) and
                             f_isBitOn(cIFS_READDIR_DIRECTORY: options)));                  //RADDAT
                                                                                            //RADDAT
                           //... then call the requested callback procedure:               //RADDAT
 B07                       select;                                                          //RADDAT
                           when (f_isBitOn(cIFS_READDIR_CB_NAME: options));                 //RADDAT
 B08                          if (not ifsDirectory_read_Path(
                                            level: directory: entry:
                                            %str(%addr(st_stat.objType)):
                                            pUserData: msg));                               //RADDAT
                                 isUserError = cTrue;                                       //RADDAT
                                 leave;                                                     //RADDAT
 E08                          endif;                                                        //RADDAT
                                                                                            //RADDAT
                              numEntries = numEntries + 1;                                  //RADDAT
                                                                                            //RADDAT
                           when (f_isBitOn(cIFS_READDIR_CB_DIRENT: options));               //RADDAT
 B08                          if (not ifsDirectory_read_Dirent(
                                            level: directory: dirent:
                                            %str(%addr(st_stat.objType)):
                                            pUserData: msg));                               //RADDAT
                                 isUserError = cTrue;                                       //RADDAT
                                 leave;                                                     //RADDAT
 E08                          endif;                                                        //RADDAT
                                                                                            //RADDAT
                              numEntries = numEntries + 1;                                  //RADDAT
                                                                                            //RADDAT
 E07                       endsl;                                                           //RADDAT
                                                                                            //RADDAT
 E06                    endif;                                                              //RADDAT
 E05                 endif;                                                                 //RADDAT
                                                                                            //RADDAT
                     //Process sub-directory                                               //RADDAT
                     //(pre-order: first callback, then subdirectory                       //RADDAT
 B05                 if (entry <> '' and isPreOrder);                                       //RADDAT
                        exsr processSubDirectory;                                           //RADDAT
 B06                    if (numSubEntries = RC_ERROR);                                      //RADDAT
                           leave;                                                           //RADDAT
 E06                    endif;                                                              //RADDAT
 E05                 endif;                                                                 //RADDAT
                                                                                            //RADDAT
 E04              endif;                                                                    //RADDAT
 E03           endif;                                                                       //RADDAT
                                                                                            //RADDAT
               //Read next entry                                                           //RADDAT
               f_clrErrno();                                                                //RADDAT
               pDirEnt = readdir(pDIR);                                                     //RADDAT
               //If we got an error ...                                                    //RADDAT
 B03           if (pDirEnt = *NULL) and (f_errno <> 0);                                     //RADDAT
                  //... then create error message                                          //RADDAT
                  clear IFS1017;                                                            //RADDAT
                  IFS10171 = directory;                                                     //RADDAT
                  IFS10172 = f_errno();                                                     //RADDAT
                  IFS10173 = f_strerror(f_errno());                                         //RADDAT
                  msg = AppMsg_newEscape('IFS1017': IFS1017);                               //RADDAT
                  leave;                                                                    //RADDAT
 E03           endif;                                                                       //RADDAT
 E02        enddo;                                                                          //RADDAT
                                                                                            //RADDAT
            //Close directory                                                              //RADDAT
 B02        if (closedir(pDIR) = RC_ERROR);                                                 //RADDAT
 B03           if (msg.ID = cMsg_ID_OK);                                                    //RADDAT
                  clear IFS1020;                                                            //RADDAT
                  IFS10201 = directory;                                                     //RADDAT
                  IFS10202 = f_errno();                                                     //RADDAT
                  IFS10203 = f_strerror(f_errno());                                         //RADDAT
                  msg = AppMsg_newEscape('IFS1020': IFS1020);                               //RADDAT
 E03           endif;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         //Set return value                                                                //RADDAT
 B01     if (msg.ID <> cMsg_ID_OK);                                                         //RADDAT
            numEntries = cIFS_ERROR;                                                        //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         //Ensure that message has been correctly set                                      //RADDAT
 B01     if (not isUserError);                                                              //RADDAT
            p_assert(msg.ID = cMsg_ID_OK or msg.type = cMsg_Escape);                        //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         //If the message parameter was passed ...                                         //RADDAT
 B01     if (%parms() >= p_msg);                                                            //RADDAT
            //... and not omitted                                                          //RADDAT
 B02        if (%addr(o_msg) <> *NULL);                                                     //RADDAT
               //Return back message                                                       //RADDAT
               o_msg = msg;                                                                 //RADDAT
 E02        endif;                                                                          //RADDAT
 X01     else;                                                                              //RADDAT
            //... else send message                                                        //RADDAT
 B02        if (msg.ID <> cMsg_ID_OK);                                                      //RADDAT
               f_sndPgmMsg(msg: cMsg_Prv);                                                  //RADDAT
 E02        endif;                                                                          //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         //Decrease call level                                                             //RADDAT
         level = level - 1;                                                                 //RADDAT
                                                                                            //RADDAT
         return numEntries;                                                                 //RADDAT
                                                                                            //RADDAT
         //- - - - - - - - - - - - - - - - - - - - - - - - - - - - -                       //RADDAT
         //   Process subdirectory                                                         //RADDAT
         //- - - - - - - - - - - - - - - - - - - - - - - - - - - - -                       //RADDAT
         begsr processSubDirectory;                                                         //RADDAT
                                                                                            //RADDAT
 B01        if (STAT_isDirectory(st_stat) and
                f_isBitOn(cIFS_READDIR_SUBDIRECTORY: options));                             //RADDAT
 B02           if (entry <> pattern);                                                       //RADDAT
                  path =ifsPath_fixSyntax(directory + entry + cSLASH + pattern);            //RADDAT
 X02           else;                                                                        //RADDAT
                  path =ifsPath_fixSyntax(directory + entry + cSLASH);                      //RADDAT
 E02           endif;                                                                       //RADDAT
               numSubEntries = ifsDirectory_read(path
                                                 : i_pCallback
                                                 : options
                                                 : pUserData
                                                 : msg);                                    //RADDAT
 B02           if (numSubEntries = RC_ERROR);                                               //RADDAT
                  leavesr;                                                                  //RADDAT
 E02           endif;                                                                       //RADDAT
                                                                                            //RADDAT
               numEntries = numEntries + numSubEntries;                                     //RADDAT
 E01        endif;                                                                          //RADDAT
                                                                                            //RADDAT
         endsr;                                                                             //RADDAT
                                                                                            //RADDAT
      /end-free
     *                                                                                       RADDAT
    P ifsDirectory_read...                                                                   RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Returns cTrue if a given directory is empty, else cFalse.                            RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_dir         - The name of a directory.                                            RADDAT
     *   o_msg         - Error message.                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   rc            - Returns cTrue if the directory is empty, else cFalse.               RADDAT
     *=========================================================================              RADDAT
    P ifsDirectory_isEmpty...                                                                RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsDirectory_isEmpty...                                                                RADDAT
     D                 PI              N                                                      RADDAT
     D i_directory                         const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D isEmpty         S               N   inz(cFalse)                                        RADDAT
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_msg           C                   const(2)                                           RADDAT
     *                                                                                       RADDAT
     *  Fields for optional parameters                                                       RADDAT
     D msg             DS                  likeds(msg_t    ) inz                              RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D isDirOpen       S               N   inz(cFalse)                                        RADDAT
     D directory       S                   like(i_directory) inz                              RADDAT
     D pDIR            S               *                     inz                              RADDAT
     D entry           S              4A                     inz                              RADDAT
     D dirEnt          DS                  likeds(dirent_t ) based(pDirEnt)                   RADDAT
     *                                                                                       RADDAT
CPY  /COPY QIFS2,IFS1017                         Entry has not been read from direct        RADDAT
CPY  /COPY QIFS2,IFS1019                         Directory '&1' not opened.                 RADDAT
CPY  /COPY QIFS2,IFS1020                         Directory '&1' not closed.                 RADDAT
     * ---------------------------------------------------------                             RADDAT
      /free
                                                                                            //RADDAT
         //Clear error message                                                             //RADDAT
         msg = AppMsg_new(cMsg_ID_OK);                                                      //RADDAT
                                                                                            //RADDAT
 B01     dou '1';                                                                           //RADDAT
                                                                                            //RADDAT
            //Fix path (slashes)                                                           //RADDAT
            directory = ifsDirectory_fixSyntax(i_directory);                                //RADDAT
                                                                                            //RADDAT
            //Check, whether the specified directory exists or not                         //RADDAT
 B02        if (not ifsDirectory_exist(directory: msg));                                    //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            //Open directory                                                               //RADDAT
            pDIR = opendir(directory);                                                      //RADDAT
 B02        if (pDIR = *NULL);                                                              //RADDAT
               //... create error message                                                  //RADDAT
               clear IFS1019;                                                               //RADDAT
               IFS10191 = directory;                                                        //RADDAT
               IFS10192 = f_errno();                                                        //RADDAT
               IFS10193 = f_strerror(f_errno());                                            //RADDAT
               msg = AppMsg_newEscape('IFS1019': IFS1019);                                  //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            isDirOpen = cTrue;                                                              //RADDAT
                                                                                            //RADDAT
            //Spin through directory entries                                               //RADDAT
            pDirEnt = *NULL;                                                                //RADDAT
 B02        dou (pDirEnt = *NULL);                                                          //RADDAT
               //Process directory entry                                                   //RADDAT
 B03           if (pDirEnt <> *NULL);                                                       //RADDAT
                  //Get entry name                                                         //RADDAT
                  entry = %subst(dirent.d_name: 1: dirent.d_namelen);                       //RADDAT
                  //Ignore '.' and '..' directory entries                                  //RADDAT
 B04              if ((entry <> '.' and entry <> '..'));                                    //RADDAT
                     leave;   //Directory is not empty!                                    //RADDAT
 E04              endif;                                                                    //RADDAT
 E03           endif;                                                                       //RADDAT
                                                                                            //RADDAT
               //Read next entry                                                           //RADDAT
               f_clrErrno();                                                                //RADDAT
               pDirEnt = readdir(pDIR);                                                     //RADDAT
 B03           if (pDirEnt = *NULL);   //End of list                                       //RADDAT
 B04              if (f_errno <> 0);                                                        //RADDAT
                     clear IFS1017;                                                         //RADDAT
                     IFS10171 = directory;                                                  //RADDAT
                     IFS10172 = f_errno();                                                  //RADDAT
                     IFS10173 = f_strerror(f_errno());                                      //RADDAT
                     msg = AppMsg_newEscape('IFS1017': IFS1017);                            //RADDAT
                     leave;                                                                 //RADDAT
 X04              else;                                                                     //RADDAT
                     isEmpty = cTrue;   //Directory is empty.                              //RADDAT
 E04              endif;                                                                    //RADDAT
 E03           endif;                                                                       //RADDAT
 E02        enddo;                                                                          //RADDAT
                                                                                            //RADDAT
 E01     enddo;                                                                             //RADDAT
                                                                                            //RADDAT
         //Close directory                                                                 //RADDAT
 B01     if (isDirOpen);                                                                    //RADDAT
 B02        if (closedir(pDIR) = RC_OK);                                                    //RADDAT
               isDirOpen = cFalse;                                                          //RADDAT
 X02        else;                                                                           //RADDAT
               clear IFS1020;                                                               //RADDAT
               IFS10201 = directory;                                                        //RADDAT
               IFS10202 = f_errno();                                                        //RADDAT
               IFS10203 = f_strerror(f_errno());                                            //RADDAT
               msg = AppMsg_newEscape('IFS1020': IFS1020);                                  //RADDAT
 E02        endif;                                                                          //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         //Ensure that message has been correctly set                                      //RADDAT
         p_assert(msg.ID = cMsg_ID_OK or msg.type = cMsg_Escape);                           //RADDAT
                                                                                            //RADDAT
         //If the message parameter was passed ...                                         //RADDAT
 B01     if (%parms() >= p_msg);                                                            //RADDAT
            //... and not omitted                                                          //RADDAT
 B02        if (%addr(o_msg) <> *NULL);                                                     //RADDAT
               //Return back message                                                       //RADDAT
               o_msg = msg;                                                                 //RADDAT
 E02        endif;                                                                          //RADDAT
 X01     else;                                                                              //RADDAT
            //... else send message                                                        //RADDAT
 B02        if (msg.ID <> cMsg_ID_OK);                                                      //RADDAT
               f_sndPgmMsg(msg: cMsg_Prv);                                                  //RADDAT
 E02        endif;                                                                          //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         return isEmpty;                                                                    //RADDAT
                                                                                            //RADDAT
      /end-free
     *                                                                                       RADDAT
    P ifsDirectory_isEmpty...                                                                RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Returns the current working directory.                                               RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   o_msg         - Error message.                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   directory     - Current directory on success, else empty string.                    RADDAT
     *=========================================================================              RADDAT
    P ifsDirectory_getCurrent...                                                             RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsDirectory_getCurrent...                                                             RADDAT
     D                 PI                         like(ifs_path_t  )                          RADDAT
     D  o_msg                                     like(msg_t       )                          RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D directory       S                   like(ifs_path_t  ) inz                             RADDAT
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_msg           C                   const(1)                                           RADDAT
     *                                                                                       RADDAT
     *  Fields for optional parameters                                                       RADDAT
     D msg             DS                  likeds(msg_t    ) inz                              RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D tmpDirectory    S           1024A   inz                                                RADDAT
     *                                                                                       RADDAT
CPY  /COPY QIFS2,IFS1029                         Failed to get the current working ...      RADDAT
     * ---------------------------------------------------------                             RADDAT
      /free
                                                                                            //RADDAT
         //Clear error message                                                             //RADDAT
         msg = AppMsg_new(cMsg_ID_OK);                                                      //RADDAT
                                                                                            //RADDAT
 B01     dou '1';                                                                           //RADDAT
                                                                                            //RADDAT
            //Get current working directory                                                //RADDAT
 B02        if (getcwd(tmpDirectory: %size(tmpDirectory)) = *NULL);                         //RADDAT
               //... create error message on error                                         //RADDAT
               clear IFS1029;                                                               //RADDAT
               IFS10291 = f_errno();                                                        //RADDAT
               IFS10292 = f_strerror(f_errno());                                            //RADDAT
               msg = AppMsg_newEscape('IFS1029': IFS1029);                                  //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            directory = ifsDirectory_fixSyntax(%str(%addr(tmpDirectory)));                  //RADDAT
 E01     enddo;                                                                             //RADDAT
                                                                                            //RADDAT
         //Ensure that message has been correctly set                                      //RADDAT
         p_assert(msg.ID = cMsg_ID_OK or msg.type = cMsg_Escape);                           //RADDAT
                                                                                            //RADDAT
         //If the message parameter was passed ...                                         //RADDAT
 B01     if (%parms() >= p_msg);                                                            //RADDAT
            //... and not omitted                                                          //RADDAT
 B02        if (%addr(o_msg) <> *NULL);                                                     //RADDAT
               //Return back message                                                       //RADDAT
               o_msg = msg;                                                                 //RADDAT
 E02        endif;                                                                          //RADDAT
 X01     else;                                                                              //RADDAT
            //... else send message                                                        //RADDAT
 B02        if (msg.ID <> cMsg_ID_OK);                                                      //RADDAT
               f_sndPgmMsg(msg: cMsg_Prv);                                                  //RADDAT
 E02        endif;                                                                          //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         return directory;                                                                  //RADDAT
                                                                                            //RADDAT
      /end-free
     *                                                                                       RADDAT
    P ifsDirectory_getCurrent...                                                             RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Changes the current working directory.                                               RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_directory   - Directory that should become the current directory.                 RADDAT
     *   o_msg         - Error message.                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   rc            - Returns cIFS_OK on success, else cIFS_ERROR.                        RADDAT
     *=========================================================================              RADDAT
    P ifsDirectory_setCurrent...                                                             RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsDirectory_setCurrent...                                                             RADDAT
     D                 PI            10I 0                                                    RADDAT
     D  i_directory                        const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)
     D  o_msg                                     like(msg_t      )                           RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D rc              S             10I 0 inz(RC_ERROR)                                      RADDAT
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_msg           C                   const(2)                                           RADDAT
     *                                                                                       RADDAT
     *  Fields for optional parameters                                                       RADDAT
     D msg             DS                  likeds(msg_t    ) inz                              RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D tmpDir          DS                  likeds(Qlg_Path_Name_t) inz                        RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     *                                                                                       RADDAT
CPY  /COPY QIFS2,IFS1030                         Failed to change the current working ...   RADDAT
     * ---------------------------------------------------------                             RADDAT
      /free
                                                                                            //RADDAT
         //Clear error message                                                             //RADDAT
         msg = AppMsg_new(cMsg_ID_OK);                                                      //RADDAT
                                                                                            //RADDAT
 B01     dou '1';                                                                           //RADDAT
                                                                                            //RADDAT
            //Prepare path name                                                            //RADDAT
            tmpDir = QLG_PATH_new(ifsDirectory_fixSyntax(i_directory));                     //RADDAT
                                                                                            //RADDAT
            //Change current working directory                                             //RADDAT
 B02        if (QlgChdir(tmpDir) <> 0);                                                     //RADDAT
               //... create error message on error                                         //RADDAT
               clear IFS1030;                                                               //RADDAT
               IFS10301 = i_directory;                                                      //RADDAT
               IFS10302 = f_errno();                                                        //RADDAT
               IFS10303 = f_strerror(f_errno());                                            //RADDAT
               msg = AppMsg_newEscape('IFS1030': IFS1030);                                  //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            rc = RC_OK;                                                                     //RADDAT
 E01     enddo;                                                                             //RADDAT
                                                                                            //RADDAT
         //Ensure that message has been correctly set                                      //RADDAT
         p_assert(msg.ID = cMsg_ID_OK or msg.type = cMsg_Escape);                           //RADDAT
                                                                                            //RADDAT
         //If the message parameter was passed ...                                         //RADDAT
 B01     if (%parms() >= p_msg);                                                            //RADDAT
            //... and not omitted                                                          //RADDAT
 B02        if (%addr(o_msg) <> *NULL);                                                     //RADDAT
               //Return back message                                                       //RADDAT
               o_msg = msg;                                                                 //RADDAT
 E02        endif;                                                                          //RADDAT
 X01     else;                                                                              //RADDAT
            //... else send message                                                        //RADDAT
 B02        if (msg.ID <> cMsg_ID_OK);                                                      //RADDAT
               f_sndPgmMsg(msg: cMsg_Prv);                                                  //RADDAT
 E02        endif;                                                                          //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         return rc;                                                                         //RADDAT
                                                                                            //RADDAT
      /end-free
     *                                                                                       RADDAT
    P ifsDirectory_setCurrent...                                                             RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Returns the creation timestamp of a given directory.                                 RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_directory   - The name of a given directory.                                      RADDAT
     *   o_msg         - Error message.                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   crtTime       - Timestamp the directory was created on success, else                RADDAT
     *                   *LOVAL.                                                             RADDAT
     *=========================================================================              RADDAT
    P ifsDirectory_getCreationTime...                                                        RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsDirectory_getCreationTime...                                                        RADDAT
     D                 PI              Z                                                      RADDAT
     D i_directory                         const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D crtTime         S               Z   inz(*LOVAL)                                        RADDAT
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_msg           C                   const(2)                                           RADDAT
     *                                                                                       RADDAT
     *  Fields for optional parameters                                                       RADDAT
     D msg             DS                  likeds(msg_t    ) inz                              RADDAT
     *                                                                                       RADDAT
     *  Local fields                                                                         RADDAT
     D tmpRC           S             10I 0 inz                                                RADDAT
     D tmpCrtTime      S               Z   inz                                                RADDAT
     *                                                                                       RADDAT
CPY  /COPY QIFS2,IFS1048                         Failed to retrieve the timestamp the ...   RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         //Retrieve file creation time ...                                                 //RADDAT
         tmpRC = FileAttr_getTime(ifsDirectory_fixSyntax(i_directory)
                                  : QP0L_ATTR_CREATE_TIME: tmpCrtTime);                     //RADDAT
 B01     if (tmpRC = RC_ERROR);                                                             //RADDAT
            clear IFS1048;                                                                  //RADDAT
            IFS10481 = i_directory;                                                         //RADDAT
            IFS10482 = f_errno();                                                           //RADDAT
            IFS10483 = f_strerror(f_errno());                                               //RADDAT
            msg = AppMsg_newEscape('IFS1048': IFS1048);                                     //RADDAT
            crtTime = *LOVAL;                                                               //RADDAT
 X01     else;                                                                              //RADDAT
            msg = AppMsg_new(cMsg_ID_OK);                                                   //RADDAT
            crtTime = tmpCrtTime;                                                           //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         //Ensure that message has been correctly set                                      //RADDAT
         p_assert(msg.ID = cMsg_ID_OK or msg.type = cMsg_Escape);                           //RADDAT
                                                                                            //RADDAT
         //If the message parameter was passed ...                                         //RADDAT
 B01     if (%parms() >= p_msg);                                                            //RADDAT
            //... and not omitted                                                          //RADDAT
 B02        if (%addr(o_msg) <> *NULL);                                                     //RADDAT
               //Return back message                                                       //RADDAT
               o_msg = msg;                                                                 //RADDAT
 E02        endif;                                                                          //RADDAT
 X01     else;                                                                              //RADDAT
            //... else send message                                                        //RADDAT
 B02        if (msg.ID <> cMsg_ID_OK);                                                      //RADDAT
               f_sndPgmMsg(msg: cMsg_Prv);                                                  //RADDAT
 E02        endif;                                                                          //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         return    crtTime;                                                                 //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P ifsDirectory_getCreationTime...                                                        RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Returns the timestamp the content of the directory was last changed.                 RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_directory   - The name of a given directory.                                      RADDAT
     *   o_msg         - Error message.                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   chgTime       - Timestamp the content of the directory was last                     RADDAT
     *                   changed on success, else *LOVAL;                                    RADDAT
     *=========================================================================              RADDAT
    P ifsDirectory_getContentChangeTime...                                                   RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsDirectory_getContentChangeTime...                                                   RADDAT
     D                 PI              Z                                                      RADDAT
     D i_directory                         const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D chgTime         S               Z   inz(*LOVAL)                                        RADDAT
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_msg           C                   const(2)                                           RADDAT
     *                                                                                       RADDAT
     *  Fields for optional parameters                                                       RADDAT
     D msg             DS                  likeds(msg_t    ) inz                              RADDAT
     *                                                                                       RADDAT
     *  Local fields                                                                         RADDAT
     D tmpRC           S             10I 0 inz                                                RADDAT
     D tmpChgTime      S               Z   inz                                                RADDAT
     *                                                                                       RADDAT
CPY  /COPY QIFS2,IFS1049                         Failed to retrieve the timestamp the ...   RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         //Retrieve the time the file data was last changed ...                            //RADDAT
         tmpRC = FileAttr_getTime(ifsDirectory_fixSyntax(i_directory)
                                  : QP0L_ATTR_MODIFY_TIME: tmpChgTime);                     //RADDAT
 B01     if (tmpRC = RC_ERROR);                                                             //RADDAT
            clear IFS1049;                                                                  //RADDAT
            IFS10491 = i_directory;                                                         //RADDAT
            IFS10492 = f_errno();                                                           //RADDAT
            IFS10493 = f_strerror(f_errno());                                               //RADDAT
            msg = AppMsg_newEscape('IFS1049': IFS1049);                                     //RADDAT
            chgTime = *LOVAL;                                                               //RADDAT
 X01     else;                                                                              //RADDAT
            msg = AppMsg_new(cMsg_ID_OK);                                                   //RADDAT
            chgTime = tmpChgTime;                                                           //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         //Ensure that message has been correctly set                                      //RADDAT
         p_assert(msg.ID = cMsg_ID_OK or msg.type = cMsg_Escape);                           //RADDAT
                                                                                            //RADDAT
         //If the message parameter was passed ...                                         //RADDAT
 B01     if (%parms() >= p_msg);                                                            //RADDAT
            //... and not omitted                                                          //RADDAT
 B02        if (%addr(o_msg) <> *NULL);                                                     //RADDAT
               //Return back message                                                       //RADDAT
               o_msg = msg;                                                                 //RADDAT
 E02        endif;                                                                          //RADDAT
 X01     else;                                                                              //RADDAT
            //... else send message                                                        //RADDAT
 B02        if (msg.ID <> cMsg_ID_OK);                                                      //RADDAT
               f_sndPgmMsg(msg: cMsg_Prv);                                                  //RADDAT
 E02        endif;                                                                          //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         return chgTime;                                                                    //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P ifsDirectory_getContentChangeTime...                                                   RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Fixes the syntax of a given directory name.                                          RADDAT
     *  (Hint:   path = directory + file)                                                    RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_directory   - A given directory name.                                             RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   directory     - The fixed directory name.                                           RADDAT
     *=========================================================================              RADDAT
    P ifsDirectory_fixSyntax...                                                              RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsDirectory_fixSyntax...                                                              RADDAT
     D                 PI                  like(ifs_path_t    )                               RADDAT
     D i_directory                         const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D directory       S                   like(ifs_path_t) inz                               RADDAT
     * ---------------------------------------------------------                             RADDAT
      /free
                                                                                            //RADDAT
         //If no directory was specified, ...                                              //RADDAT
 B01     if (i_directory = '');                                                             //RADDAT
         //... then return to caller                                                       //RADDAT
            return i_directory;                                                             //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         //Translate backslashes ('\') to slashes ('/')                                    //RADDAT
         directory = %xlate(cBACKSLASH: cSLASH: i_directory);                               //RADDAT
                                                                                            //RADDAT
         //Append missing slash                                                            //RADDAT
 B01     if (not f_endsWith(cSLASH: directory));                                            //RADDAT
            directory = directory + cSLASH;                                                 //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         return directory;                                                                  //RADDAT
                                                                                            //RADDAT
      /end-free
     *                                                                                       RADDAT
    P ifsDirectory_fixSyntax...                                                              RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
   R *  *** private ***                                                                      RADDAT
     *  Deletes all entries of a given directory and its subdirectories.                     RADDAT
     *=========================================================================              RADDAT
    P clearDirectory...                                                                      RADDAT
    P                 B                                                                      RADDAT
     *                                                                                       RADDAT
     D clearDirectory...                                                                      RADDAT
     D                 PI              N                                                      RADDAT
     D  i_level                      10I 0 const                                              RADDAT
     D  i_directory                        const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)
     D  i_entry                            const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)
     D  i_type                             const  like(ifs_type_t    )                        RADDAT
     D  i_pUsrDta                      *   const                                              RADDAT
     D  o_msg                                     like(msg_t         )                        RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D tmpRC           S             10I 0 inz                                                RADDAT
     D tmpPath         S                   like(ifs_path_t ) inz                              RADDAT
     D tmpMsg          DS                  likeds(msg_t    ) inz                              RADDAT
     *                                                                                       RADDAT
     *  User data                                                                            RADDAT
     D usrDta          DS                  likeds(clrDirUsrDta_t )                            RADDAT
     D                                     based(i_pUsrDta)                                   RADDAT
     * ---------------------------------------------------------                             RADDAT
      /free
                                                                                            //RADDAT
         tmpPath = i_directory + i_entry;                                                   //RADDAT
                                                                                            //RADDAT
 B01     select;                                                                            //RADDAT
         when (i_type = cIFS_DIRENT_TYPE_DIRECTORY or
               i_type = cIFS_DIRENT_TYPE_FOLDER);                                           //RADDAT
            tmpRC = ifsDirectory_remove(tmpPath: usrDta.options: tmpMsg);                   //RADDAT
 B02        if (tmpRC = cIFS_ERROR);                                                        //RADDAT
               o_msg = tmpMsg;                                                              //RADDAT
               return cFalse;                                                               //RADDAT
 X02        else;                                                                           //RADDAT
               usrDta.numE = usrDta.numE + tmpRC;                                           //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
         when (i_type = cIFS_DIRENT_TYPE_FILE or
               i_type = cIFS_DIRENT_TYPE_DOCUMENT);                                         //RADDAT
 B02        if (ifsFile_delete(tmpPath: tmpMsg) = cIFS_ERROR);                              //RADDAT
               o_msg = tmpMsg;                                                              //RADDAT
               return cFalse;                                                               //RADDAT
 X02        else;                                                                           //RADDAT
               usrDta.numE = usrDta.numE + 1;                                               //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
 E01     endsl;                                                                             //RADDAT
                                                                                            //RADDAT
         o_msg = AppMsg_new(cMsg_ID_OK);                                                    //RADDAT
                                                                                            //RADDAT
         return cTrue;                                                                      //RADDAT
                                                                                            //RADDAT
      /end-free
     *                                                                                       RADDAT
    P clearDirectory...                                                                      RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
