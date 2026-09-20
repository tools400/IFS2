     *=====================================================================*                 RADDAT
     *  IFS2R01    - Tools/400: Stream File and Directory - File           *                 RADDAT
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
     H COPYRIGHT('V1.9 - 29.01.2009 - mailto:thomas.raddatz@tools400.de -                     RADDAT
     H            -                                                                           RADDAT
     H            PKGMGR(version=1.9; +                                                       RADDAT
     H                   date=29.01.2009; +                                                   RADDAT
     H                   domain=de.tools400.ifs2.)')                                          RADDAT
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
CPY  /COPY QBASICS1,PBASICS1                     Tools/400 Runtime Library                  RADDAT
CPY  /COPY QIFS2,PIFS2R04                        App.Msg                                    RADDAT
CPY  /COPY QIFS2,PIFS2R05                        Application                                RADDAT
CPY  /COPY QIFS2,PIFS2R99                        Miscellaneous                              RADDAT
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  Private prototypes                                                                   RADDAT
     * ------------------------------------                                                  RADDAT
     *                                                                                       RADDAT
     *  Checks the size of a given handle buffer and reallocates memory                      RADDAT
     *  if the buffer is too small.                                                          RADDAT
     D checkHandleBufferSizeAndReallocate...                                                  RADDAT
     D                 PR              *                                                      RADDAT
     D                                     extproc('checkHandleBufferSize+                    RADDAT
     D                                     AndReallocate')                                    RADDAT
     D io_buffer                                  likeds(buffer_t )                           RADDAT
     D i_newSize                     10I 0 const                                              RADDAT
     *                                                                                       RADDAT
     *  Free a given temporary buffer.                                                       RADDAT
     D freeHandleBuffer...
     D                 PR                                                                     RADDAT
     D                                     extproc('freeHandleBuffer')                        RADDAT
     D io_buffer                                  likeds(buffer_t )                           RADDAT
     *                                                                                       RADDAT
     *  Produces a unique file ID.                                                           RADDAT
     D produceUniqueFileID...                                                                 RADDAT
     D                 PR                         likeds(ifs_uniqueFileID_t )                 RADDAT
     D                                     extproc('produceUniqueFileID')                     RADDAT
     D i_st_stat                           const  likeds(st_stat_t    )                       RADDAT
     *                                                                                       RADDAT
     *  Produces a file ID as shown at the WRKLNK 'Display Attributes' screen.               RADDAT
     D produceFileID...                                                                       RADDAT
     D                 PR                         like(ifs_fileID_t   )
     D                                     extproc('produceFileID')                           RADDAT
     D i_st_stat                           const  likeds(st_stat_t    )                       RADDAT
     *                                                                                       RADDAT
     *  Append the data of a given file to a target file.                                    RADDAT
     D copyFileCreateOrAppend...                                                              RADDAT
     D                 PR              N                                                      RADDAT
     D                                     extproc('copyFileCreateOrAppend')                  RADDAT
     D  i_fromPath                         const  like(ifs_path_t    )                        RADDAT
     D  i_toPath                           const  like(ifs_path_t    )                        RADDAT
     D  i_toCcsid                          const  like(ifs_ccsid_t   )                        RADDAT
     D  o_msg                                     like(msg_t         )                        RADDAT
     *                                                                                       RADDAT
     *  Compares the given buffers with each other.                                          RADDAT
     D compareBuffers...                                                                      RADDAT
     D                 PR            10I 0                                                    RADDAT
     D                                     extproc('compareBuffers')                          RADDAT
     D i_pBuffer1                      *   const                                              RADDAT
     D i_pBuffer2                      *   const                                              RADDAT
     D i_size                        10I 0 const                                              RADDAT
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  Type definitions                                                                     RADDAT
     * ------------------------------------                                                  RADDAT
CPY  /COPY QIFS2,TYPES                                                                      RADDAT
     *                                                                                       RADDAT
     D handle_t...                                                                            RADDAT
     D                 DS                  qualified               based(pDummy)              RADDAT
     D  hFileUnix                    10I 0                                                    RADDAT
     D  useWriteBuffer...                                                                     RADDAT
     D                                 N                                                      RADDAT
     D  reserved_1                    5A                                                      RADDAT
     D  writeBuffer                        likeds(buffer_t )                                  RADDAT
     D  path                               like(ifs_path_t )                                  RADDAT
     *                                                                                       RADDAT
     D buffer_t        DS                  qualified               based(pDummy)              RADDAT
     D  pData                          *                                                      RADDAT
     D  size                         10I 0                                                    RADDAT
     D  reserved_1                   12A                                                      RADDAT
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  Global constants                                                                     RADDAT
     * ------------------------------------                                                  RADDAT
     *                                                                                       RADDAT
     D cBUFFER_SIZE    C                   8196                                               RADDAT
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  Global fields                                                                        RADDAT
     * ------------------------------------                                                  RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Returns cTrue if the specified file exists, else cFalse.                             RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_path        - The name of a stream file.                                          RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   doesExist     - Returns cTrue if the file exists, else cFalse.                      RADDAT
     *=========================================================================              RADDAT
    P ifsFile_exist...                                                                       RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsFile_exist...                                                                       RADDAT
     D                 PI              N                                                      RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
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
CPY  /COPY QIFS2,IFS1036                         Failed to retrieve file information.       RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         f_clrErrno();                                                                      //RADDAT
                                                                                            //RADDAT
         //If the object could not be found, ...                                           //RADDAT
 B01     if (stat(ifsPath_fixSyntax(i_path): %addr(st_stat)) = RC_ERROR);                   //RADDAT
            //... check error code to ensure that it is 3025 "no such file or directory"   //RADDAT
 B02        if (f_errno() <> ENOENT_C);                                                     //RADDAT
               clear IFS1036;                                                               //RADDAT
               IFS10361 = i_path;                                                           //RADDAT
               IFS10362 = f_errno();                                                        //RADDAT
               IFS10363 = f_strerror(f_errno());                                            //RADDAT
               Application_killWithMsg(AppMsg_newEscape('IFS1036': IFS1036));               //RADDAT
 E02        endif;                                                                          //RADDAT
            return cFalse;                                                                  //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         //Ensure that the object is a file and not a directory.                           //RADDAT
 B01     if (not STAT_isFile(st_stat));                                                     //RADDAT
            return cFalse;                                                                  //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         return cTrue;                                                                      //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P ifsFile_exist...                                                                       RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Opens a given stream file.                                                           RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_path        - A given IFS path name.                                              RADDAT
     *   i_opnFlags    - O_CREAT        If the file being opened does not exist,             RADDAT
     *                                  create it.                                           RADDAT
     *                   O_EXCL         Send error message if file exists and                RADDAT
     *                                  O_CREAT was specified.                               RADDAT
     *                   O_TRUNC        Truncate the file to zero length.                    RADDAT
     *                   O_APPEND       Position the file offset at the end of               RADDAT
     *                                  the file before each write operation.                RADDAT
     *                   O_CODEPAGE     The call to open has a codepage argument.            RADDAT
     *                                  This flag cannot be specified with the               RADDAT
     *                                  O_CCSID flag.                                        RADDAT
     *                   O_TEXTDATA     The data is processed as text.                       RADDAT
     *                   O_INHERITMODE  Create the file with the same data                   RADDAT
     *                                  authorities as the parent file.                      RADDAT
     *                   O_CCSID        Text conversions between any two CCSIDs              RADDAT
     *                                  supported by the iconv() API can be performed.       RADDAT
     *                                  This flag cannot be specified with the               RADDAT
     *                                  O_CODEPAGE flag.                                     RADDAT
     *                                                                                       RADDAT
     *                   O_SHARE_RDONLY Share with readers only.                             RADDAT
     *                   O_SHARE_WRONLY Share with writers only.                             RADDAT
     *                   O_SHARE_RDWR   Share with readers and writers.                      RADDAT
     *                   O_SHARE_NONE   Share with neither readers nor writers.              RADDAT
     *                                                                                       RADDAT
     *                   O_RDONLY       Open for reading only.                               RADDAT
     *                   O_WRONLY       Open for writing only.                               RADDAT
     *                   O_RDWR         Open for both reading and writing.                   RADDAT
     *                                                                                       RADDAT
     *   i_codePage    - When the O_CODEPAGE flag is specified, i_codepage                   RADDAT
     *                   must contain the codepage of the new file.                          RADDAT
     *                   When the O_CCSID flag is specified, i_codepage                      RADDAT
     *                   must contain the CCSID of the new file.                             RADDAT
     *   i_auth        - S_IRUSR        Owner has read authority.                            RADDAT
     *                   S_IWUSR        Owner has write authority.                           RADDAT
     *                   S_IXUSR        Owner has execute/search authority.                  RADDAT
     *                   S_IRWXU        Owner has all authorities.                           RADDAT
     *                                                                                       RADDAT
     *                   S_IRGRP        Group has read authority.                            RADDAT
     *                   S_IWGRP        Group has write authority.                           RADDAT
     *                   S_IXGRP        Group has execute/search authority.                  RADDAT
     *                   S_IRWXG        Group has all authorities.                           RADDAT
     *                                                                                       RADDAT
     *                   S_IROTH        Public has read authority.                           RADDAT
     *                   S_IWOTH        Public has write authority.                          RADDAT
     *                   S_IXOTH        Public has execute/search authority.                 RADDAT
     *                   S_IRWXO        Public has all authorities.                          RADDAT
     *   o_msg         - Error message.                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   hFile         - The handle of the open file.                                        RADDAT
     *=========================================================================              RADDAT
    P ifsFile_open...                                                                        RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsFile_open...                                                                        RADDAT
     D                 PI                  like(ifs_hFile_t   )                               RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)
     D i_opnFlags                    10I 0 const                                              RADDAT
     D i_codePage                    10I 0 const  options(*nopass: *omit)                     RADDAT
     D i_auth                        10I 0 const  options(*nopass: *omit)                     RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D hFile           S                   like(ifs_hFile_t) inz                              RADDAT
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_codePage      C                   const(3)                                           RADDAT
     D p_auth          C                   const(4)                                           RADDAT
     D p_msg           C                   const(5)                                           RADDAT
     *                                                                                       RADDAT
     *  Fields for optional parameters                                                       RADDAT
     D codePage        S                   like(i_codePage)  inz                              RADDAT
     D auth            S                   like(i_auth    )  inz                              RADDAT
     D msg             DS                  likeds(msg_t    ) inz                              RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D path            S                   like(i_path    )  inz                              RADDAT
     D opnFlags        S                   like(i_opnFlags)  inz                              RADDAT
     D doesExist       S               N                     inz(cFalse)                      RADDAT
     D rc              S             10I 0                   inz                              RADDAT
     D hFileUnix       S             10I 0                   inz                              RADDAT
     *                                                                                       RADDAT
     *  File handle                                                                          RADDAT
     D handle          DS                  likeds(handle_t ) based(pHandle)                   RADDAT
     *                                                                                       RADDAT
CPY  /COPY QIFS2,IFS1000                         Failed to open file '&1'.                  RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         //Process optional parameters ...                                                 //RADDAT
         //... i_codePage                                                                  //RADDAT
 B01     if (%parms() >= p_codePage and %addr(i_codePage) <> *NULL);                        //RADDAT
            codePage = i_codePage;                                                          //RADDAT
 X01     else;                                                                              //RADDAT
            codePage = cDFT_ASC_CODEPAGE;
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         //... i_auth                                                                      //RADDAT
 B01     if (%parms() >= p_auth and %addr(i_auth) <> *NULL);                                //RADDAT
            auth = i_auth;                                                                  //RADDAT
 X01     else;                                                                              //RADDAT
            auth = S_IRWXU + S_IRWXG + S_IRWXO;  //*PUBLIC = *ALL                          //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         //Initialize return value                                                         //RADDAT
         hFile = HANDLE_null();                                                             //RADDAT
                                                                                            //RADDAT
         //Clear error message                                                             //RADDAT
         msg = AppMsg_new(cMsg_ID_OK);                                                      //RADDAT
                                                                                            //RADDAT
         //Fix path (slashes)                                                              //RADDAT
         path = ifsPath_fixSyntax(i_path);                                                  //RADDAT
                                                                                            //RADDAT
         //Check file existance                                                            //RADDAT
         doesExist = ifsFile_exist(path);                                                   //RADDAT
                                                                                            //RADDAT
         //Set open flags                                                                  //RADDAT
         opnFlags = i_opnFlags;                                                             //RADDAT
                                                                                            //RADDAT
         //If O_CODEPAGE and O_CCSID are not specified ...                                 //RADDAT
 B01     if (not f_isBitOn(O_CODEPAGE: opnFlags) and
             not f_isBitOn(O_CCSID   : opnFlags));                                          //RADDAT
            //... and the file does not exists                                             //RADDAT
 B02        if (not doesExist);                                                             //RADDAT
               //... then set O_CODEPAGE                                                   //RADDAT
               opnFlags = opnFlags + O_CODEPAGE;                                            //RADDAT
 E02        endif;                                                                          //RADDAT
 X01     else;                                                                              //RADDAT
            //... else if the file already exists                                          //RADDAT
 B02        if (doesExist);                                                                 //RADDAT
               //... then remove O_CODEPAGE or O_CCSID                                     //RADDAT
 B03           select;                                                                      //RADDAT
               when f_isBitOn(O_CODEPAGE: opnFlags);                                        //RADDAT
                  opnFlags = opnFlags - O_CODEPAGE;                                         //RADDAT
               when f_isBitOn(O_CCSID   : opnFlags);                                        //RADDAT
                  opnFlags = opnFlags - O_CCSID;                                            //RADDAT
 E03           endsl;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         //Open the file                                                                   //RADDAT
         hFileUnix = open(path: opnFlags: auth: codePage);                                  //RADDAT
                                                                                            //RADDAT
         //If the file was just created ...                                                //RADDAT
 B01     if (hFileUnix <> RC_ERROR and not doesExist);                                      //RADDAT
            //... then re-open the file to let the operating system                        //RADDAT
            //    do codepage conversion.                                                  //RADDAT
 B02        if (close(hFileUnix) = RC_ERROR);                                               //RADDAT
               hFileUnix = RC_ERROR;                                                        //RADDAT
 X02        else;                                                                           //RADDAT
               //Remove the O_CODEPAGE or O_CCSID flag
 B03           select;                                                                      //RADDAT
               when f_isBitOn(O_CODEPAGE: opnFlags);                                        //RADDAT
                  opnFlags = opnFlags - O_CODEPAGE;                                         //RADDAT
               when f_isBitOn(O_CCSID   : opnFlags);                                        //RADDAT
                  opnFlags = opnFlags - O_CCSID;                                            //RADDAT
 E03           endsl;                                                                       //RADDAT
               //Remove the O_CREAT flag                                                   //RADDAT
 B03           if (f_isBitOn(O_CREAT: opnFlags));                                           //RADDAT
                  opnFlags = opnFlags - O_CREAT;                                            //RADDAT
 E03           endif;                                                                       //RADDAT
               //Re-open the file                                                          //RADDAT
               hFileUnix = open(path: opnFlags);                                            //RADDAT
 E02        endif;                                                                          //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         //In case on an open error ...                                                    //RADDAT
 B01     if (hFileUnix = RC_ERROR);                                                         //RADDAT
            //... create error message                                                     //RADDAT
            clear IFS1000;                                                                  //RADDAT
            IFS10001 = path;                                                                //RADDAT
            IFS10002 = f_errno();                                                           //RADDAT
            IFS10003 = f_strerror(f_errno());                                               //RADDAT
            msg = AppMsg_newEscape('IFS1000': IFS1000);                                     //RADDAT
 X01     else;                                                                              //RADDAT
            //... else produce a file handle                                               //RADDAT
            hFile = HANDLE_new('*IFS2': %size(handle_t));                                   //RADDAT
            pHandle = HANDLE_getPointer(hFile);                                             //RADDAT
                                                                                            //RADDAT
            clear handle;                                                                   //RADDAT
            handle.hFileUnix = hFileUnix;                                                   //RADDAT
            handle.path      = path;                                                        //RADDAT
            handle.useWriteBuffer = (f_isBitOn(O_SHARE_WRONLY: opnFlags) or
                                     f_isBitOn(O_SHARE_RDWR  : opnFlags)) and
                                    (f_isBitOn(O_WRONLY: opnFlags) or
                                     f_isBitOn(O_RDWR  : opnFlags));                        //RADDAT
                                                                                            //RADDAT
            p_assert(handle.writeBuffer.pData = *NULL and
                     handle.writeBuffer.size = 0
                     : 'Handle buffer not correctly initialized');                          //RADDAT
                                                                                            //RADDAT
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
         return hFile;                                                                      //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P ifsFile_open...                                                                        RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Closes an stream file that has been opened with the                                  RADDAT
     *  ifsFile_open-function.                                                               RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_hFile       - The handle of a file as returned by ifsFile_open().                 RADDAT
     *   o_msg         - Error message.                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   rc            - Returns cIFS_OK on success, else cIFS_ERROR.                        RADDAT
     *=========================================================================              RADDAT
    P ifsFile_close...                                                                       RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsFile_close...                                                                       RADDAT
     D                 PI            10I 0                                                    RADDAT
     D io_hFile                                   like(ifs_hFile_t   )                        RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D rc              S             10I 0 inz(cIFS_ERROR)                                    RADDAT
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_msg           C                   const(2)                                           RADDAT
     *                                                                                       RADDAT
     *  Fields for optional parameters                                                       RADDAT
     D msg             DS                  likeds(msg_t    ) inz                              RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D tmpRC           S             10I 0 inz                                                RADDAT
     *                                                                                       RADDAT
     *  File handle                                                                          RADDAT
     D handle          DS                  likeds(handle_t ) based(pHandle)                   RADDAT
     *                                                                                       RADDAT
CPY  /COPY QIFS2,IFS1001                         Could not close file '&2'.                 RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         //Get access to file handle date                                                  //RADDAT
         pHandle = HANDLE_getPointer(io_hFile);                                             //RADDAT
                                                                                            //RADDAT
         //Close file                                                                      //RADDAT
         tmpRC = close(handle.hFileUnix);                                                   //RADDAT
                                                                                            //RADDAT
         //If we got an error                                                              //RADDAT
 B01     if (tmpRC = RC_ERROR);                                                             //RADDAT
            //... then create error message                                                //RADDAT
            clear IFS1001;                                                                  //RADDAT
            IFS10011 = handle.path;                                                         //RADDAT
            IFS10012 = f_errno();                                                           //RADDAT
            IFS10013 = f_strerror(f_errno());                                               //RADDAT
            msg = AppMsg_newEscape('IFS1001': IFS1001);                                     //RADDAT
            rc = cIFS_ERROR;                                                                //RADDAT
 X01     else;                                                                              //RADDAT
            //... else free temporary write buffer                                         //RADDAT
            freeHandleBuffer(handle.writeBuffer);                                           //RADDAT
                                                                                            //RADDAT
            //... free file handle                                                         //RADDAT
            HANDLE_delete(io_hFile);                                                        //RADDAT
                                                                                            //RADDAT
            msg = AppMsg_new(cMSG_ID_OK);                                                   //RADDAT
            rc = cIFS_OK;                                                                   //RADDAT
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
         return rc;                                                                         //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P ifsFile_close...                                                                       RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Deletes a given stream file.                                                         RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_path        - The path name of the stream file to delete.                         RADDAT
     *   o_msg         - Error message.                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   rc            - Returns cIFS_OK on success, else cIFS_ERROR.                        RADDAT
     *=========================================================================              RADDAT
    P ifsFile_delete...                                                                      RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsFile_delete...                                                                      RADDAT
     D                 PI            10I 0                                                    RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D rc              S             10I 0 inz                                                RADDAT
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_msg           C                   const(2)                                           RADDAT
     *                                                                                       RADDAT
     *  Fields for optional parameters                                                       RADDAT
     D msg             DS                  likeds(msg_t    ) inz                              RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D tmpRC           S             10I 0 inz                                                RADDAT
     *                                                                                       RADDAT
CPY  /COPY QIFS2,IFS1005                         Failed to delete file '&1'.                RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         //Delete IFS file                                                                 //RADDAT
         tmpRC = unlink(ifsPath_fixSyntax(i_path));                                         //RADDAT
                                                                                            //RADDAT
         //If we got an error, ...                                                         //RADDAT
 B01     if (tmpRC = RC_ERROR);                                                             //RADDAT
            //... then create error message                                                //RADDAT
            clear IFS1005;                                                                  //RADDAT
            IFS10051 = i_path;                                                              //RADDAT
            IFS10052 = f_errno();                                                           //RADDAT
            IFS10053 = f_strerror(f_errno());                                               //RADDAT
            msg = AppMsg_newEscape('IFS1005': IFS1005);                                     //RADDAT
            rc = cIFS_ERROR;                                                                //RADDAT
 X01     else;                                                                              //RADDAT
            //... else create OK message                                                   //RADDAT
            msg = AppMsg_new(cMSG_ID_OK);                                                   //RADDAT
            rc = cIFS_OK;                                                                   //RADDAT
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
         return rc;                                                                         //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P ifsFile_delete...                                                                      RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Moves a given stream file to a new location.                                         RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_fromPath    - The path name of a given stream file.                               RADDAT
     *   i_toDirectory - The name of the target directory.                                   RADDAT
     *   i_options     - Options:                                                            RADDAT
     *                   cIFS_MOVE_FILE_DFT       Default settings.                          RADDAT
     *                   cIFS_MOVE_FILE_REPLACE   Replace existing target file.              RADDAT
     *                   cIFS_MOVE_FILE_ALLOW_RENAME       Move and rename file.             RADDAT
     *                   cIFS_MOVE_FILE_CREATE_DIRECTORY   Create TO directory               RADDAT
     *                                                     if it does not exist.             RADDAT
     *   o_msg         - Error message.                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   rc            - Returns cIFS_OK on success, else cIFS_ERROR.                        RADDAT
     *=========================================================================              RADDAT
    P ifsFile_move...                                                                        RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsFile_move...                                                                        RADDAT
     D                 PI            10I 0                                                    RADDAT
     D i_fromPath                          const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)
     D i_toDirectory                       const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)
     D  i_options                    10I 0 const  options(*nopass: *omit)                     RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D rc              S             10I 0 inz                                                RADDAT
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_options       C                   const(3)                                           RADDAT
     D p_msg           C                   const(4)                                           RADDAT
     *                                                                                       RADDAT
     *  Fields for optional parameters                                                       RADDAT
     D options         S                   like(i_options  ) inz                              RADDAT
     D msg             DS                  likeds(msg_t    ) inz                              RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D tmpRC           S             10I 0 inz                                                RADDAT
     D fromPath        S                   like(ifs_path_t ) inz                              RADDAT
     D toPath          S                   like(ifs_path_t ) inz                              RADDAT
     D toFileName      S                   like(ifs_path_t ) inz                              RADDAT
     D toDirectory     S                   like(ifs_path_t ) inz                              RADDAT
     *                                                                                       RADDAT
CPY  /COPY QIFS2,IFS1003                         Failed to move file '&1' to '&2'.          RADDAT
CPY  /COPY QIFS2,IFS1011                         Directory '&1' does not exist.             RADDAT
CPY  /COPY QIFS2,IFS1012                         File '&1' does not exist.                  RADDAT
CPY  /COPY QIFS2,IFS1047                         Directory name '&1' contains invalid ...   RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         //Process optional parameters ...                                                 //RADDAT
         //... i_options                                                                   //RADDAT
 B01     if (%parms() >= p_options and %addr(i_options) <> *NULL);                          //RADDAT
            options = i_options;                                                            //RADDAT
 X01     else;                                                                              //RADDAT
            options = cIFS_MOVE_FILE_DFT;                                                   //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         msg = AppMsg_new(cMsg_ID_OK);                                                      //RADDAT
                                                                                            //RADDAT
 B01     dou '1';                                                                           //RADDAT
                                                                                            //RADDAT
            fromPath    = ifsPath_fixSyntax(i_fromPath);                                    //RADDAT
                                                                                            //RADDAT
            //If the file does not exist, ...                                              //RADDAT
 B02        if (not ifsFile_exist(fromPath));                                               //RADDAT
               //... then create an error message                                          //RADDAT
               clear IFS1012;                                                               //RADDAT
               IFS10121 = fromPath;                                                         //RADDAT
               msg = AppMsg_newEscape('IFS1012': IFS1012);                                  //RADDAT
               rc = cIFS_ERROR;                                                             //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            //If the target directory name contains a file name, ...                       //RADDAT
            toFileName = ifsPath_getName(i_toDirectory);                                    //RADDAT
                                                                                            //RADDAT
 B02        if (toFileName <> '' and toFileName <> ifsPath_getName(fromPath));              //RADDAT
 B03           if (not f_isBitOn(cIFS_MOVE_FILE_ALLOW_RENAME: options));                    //RADDAT
                  //... then create error message                                          //RADDAT
                  clear IFS1047;                                                            //RADDAT
                  IFS10471 = i_toDirectory;                                                 //RADDAT
                  msg = AppMsg_newEscape('IFS1047': IFS1047);                               //RADDAT
                  rc = cIFS_ERROR;                                                          //RADDAT
                  leave;                                                                    //RADDAT
 E03           endif;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
 B02        if (toFileName = '');                                                           //RADDAT
               toDirectory = ifsDirectory_fixSyntax(i_toDirectory);                         //RADDAT
 X02        else;                                                                           //RADDAT
               toDirectory = ifsPath_getDirectory(
                                   ifsPath_fixSyntax(i_toDirectory));                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            //If the target directory does not exist, ...                                  //RADDAT
 B02        if (not ifsDirectory_exist(toDirectory));                                       //RADDAT
 B03           if (not f_isBitOn(cIFS_MOVE_FILE_CREATE_DIRECTORY: options));                //RADDAT
                  //... then create error message                                          //RADDAT
                  clear IFS1011;                                                            //RADDAT
                  IFS10111 = toDirectory;                                                   //RADDAT
                  msg = AppMsg_newEscape('IFS1011': IFS1011);                               //RADDAT
                  rc = cIFS_ERROR;                                                          //RADDAT
                  leave;                                                                    //RADDAT
 E03           endif;                                                                       //RADDAT
                                                                                            //RADDAT
 B03           if (ifsDirectory_create(
                      toDirectory: cIFS_MKDIR_SUBDIR: *omit: msg) = cIFS_ERROR);
                  rc = cIFS_ERROR;                                                          //RADDAT
                  leave;                                                                    //RADDAT
 E03           endif;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            //Produce target path                                                          //RADDAT
 B02        if (toFilename = '');                                                           //RADDAT
               toPath = toDirectory + ifsPath_getName(fromPath);                            //RADDAT
 X02        else;                                                                           //RADDAT
               toPath = toDirectory + toFileName;                                           //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            //Move stream file ...                                                         //RADDAT
 B02        if (f_isBitOn(cIFS_MOVE_FILE_REPLACE: options));                                //RADDAT
               //... replace existing file.                                                //RADDAT
               tmpRC = Qp0lRenameUnlink(fromPath: toPath);                                  //RADDAT
 X02        else;                                                                           //RADDAT
               //... return ERROR message in case the target file exists                   //RADDAT
               tmpRC = Qp0lRenameKeep(fromPath: toPath);                                    //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            //If we got an error                                                           //RADDAT
 B02        if (tmpRC = RC_ERROR);                                                          //RADDAT
            //... then create message                                                      //RADDAT
               clear IFS1003;                                                               //RADDAT
               IFS10031 = fromPath;                                                         //RADDAT
               IFS10032 = toDirectory;                                                      //RADDAT
               IFS10033 = f_errno();                                                        //RADDAT
               IFS10034 = f_strerror(f_errno());                                            //RADDAT
               msg = AppMsg_newEscape('IFS1003': IFS1003);                                  //RADDAT
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
    P ifsFile_move...                                                                        RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Renames a given IFS file.                                                            RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_fromPath    - Renames a given stream file.                                        RADDAT
     *   i_toFile      - The new file name.                                                  RADDAT
     *   o_msg         - Error message.                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   rc            - Returns cIFS_OK on success, else CIFS_ERROR.                        RADDAT
     *=========================================================================              RADDAT
    P ifsFile_rename...                                                                      RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsFile_rename...                                                                      RADDAT
     D                 PI            10I 0                                                    RADDAT
     D i_fromPath                          const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)
     D i_toFile                            const  like(ifs_path_t    )                        RADDAT
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
CPY  /COPY QIFS2,IFS1009                         Failed to rename file '&1' to '&2'.        RADDAT
CPY  /COPY QIFS2,IFS1012                         File '&1' does not exist.                  RADDAT
CPY  /COPY QIFS2,IFS1013                         File '&1' already exits.                   RADDAT
CPY  /COPY QIFS2,IFS1014                         File name '&1' contains invalid ...        RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         msg = AppMsg_new(cMsg_ID_OK);                                                      //RADDAT
                                                                                            //RADDAT
 B01     dou '1';                                                                           //RADDAT
                                                                                            //RADDAT
            //If the file does not exist, ...                                              //RADDAT
 B02        if (not ifsFile_exist(i_fromPath));                                             //RADDAT
               //... then create an error message                                          //RADDAT
               clear IFS1012;                                                               //RADDAT
               IFS10121 = i_fromPath;                                                       //RADDAT
               msg = AppMsg_newEscape('IFS1012': IFS1012);                                  //RADDAT
               rc = cIFS_ERROR;                                                             //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            //If the target file name contains a directory, ...                            //RADDAT
 B02        if (not ifsPath_isNameOnly(i_toFile));                                          //RADDAT
               //... then create error message                                             //RADDAT
               rc = RC_ERROR;                                                               //RADDAT
               clear IFS1014;                                                               //RADDAT
               IFS10141 = %trim(i_toFile);                                                  //RADDAT
               msg = AppMsg_newEscape('IFS1014': IFS1014);                                  //RADDAT
               rc = cIFS_ERROR;                                                             //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            //Compute path of target file                                                  //RADDAT
            toPath = ifsPath_fixSyntax(
                        ifsPath_getDirectory(i_fromPath) + i_toFile);                       //RADDAT
                                                                                            //RADDAT
            //If the target file does already exist, ...                                   //RADDAT
 B02        if (ifsFile_exist(toPath));                                                     //RADDAT
               //... then create error message                                             //RADDAT
               clear IFS1013;                                                               //RADDAT
               IFS10131 = toPath;                                                           //RADDAT
               msg = AppMsg_newEscape('IFS1013': IFS1013);                                  //RADDAT
               rc = cIFS_ERROR;                                                             //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            //Rename stream file                                                           //RADDAT
            tmpRC = Qp0lRenameKeep(ifsPath_fixSyntax(i_fromPath): toPath);                  //RADDAT
                                                                                            //RADDAT
            //If we got an error, ...                                                      //RADDAT
 B02        if (tmpRC = RC_ERROR);                                                          //RADDAT
            //... then create error message                                                //RADDAT
               clear IFS1009;                                                               //RADDAT
               IFS10091 = i_fromPath;                                                       //RADDAT
               IFS10092 = i_toFile;                                                         //RADDAT
               IFS10093 = f_errno();                                                        //RADDAT
               IFS10094 = f_strerror(f_errno());                                            //RADDAT
               msg = AppMsg_newEscape('IFS1009': IFS1009);                                  //RADDAT
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
    P ifsFile_rename...                                                                      RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Copyies a given file to a directory or another file.                                 RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_fromPath    - The that shall be copied.                                           RADDAT
     *   i_toPath      - The new path name.                                                  RADDAT
     *   i_options     - Options:                                                            RADDAT
     *                   cIFS_COPY_FILE_DFT       Default settings.                          RADDAT
     *                   cIFS_COPY_FILE_REPLACE   Replace existing target file.              RADDAT
     *                   cIFS_COPY_FILE_APPEND    Append file to target file.                RADDAT
     *                   cIFS_COPY_FILE_CREATE_DIRECTORY   Create TO directory               RADDAT
     *                                                     if it does not exist.             RADDAT
     *   i_ccsid       - CCSID of the target file.                                           RADDAT
     *   o_msg         - Error message.                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   rc            - Returns cIFS_OK on success, else CIFS_ERROR.                        RADDAT
     *=========================================================================              RADDAT
    P ifsFile_copy...                                                                        RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsFile_copy...                                                                        RADDAT
     D                 PI            10I 0                                                    RADDAT
     D  i_fromPath                         const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D  i_toPath                           const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D  i_options                    10I 0 const  options(*nopass: *omit)                     RADDAT
     D  i_ccsid                            const  like(ifs_ccsid_t   )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     D  o_msg                                     like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D rc              S             10I 0 inz                                                RADDAT
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_options       C                   const(3)                                           RADDAT
     D p_ccsid         C                   const(4)                                           RADDAT
     D p_msg           C                   const(5)                                           RADDAT
     *                                                                                       RADDAT
     *  Fields for optional parameters                                                       RADDAT
     D options         S                   like(i_options  ) inz                              RADDAT
     D ccsid           S                   like(i_ccsid    ) inz                              RADDAT
     D msg             DS                  likeds(msg_t    ) inz                              RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D fileExist       S               N   inz(cFalse)                                        RADDAT
     D appendFile      S               N   inz(cFalse)                                        RADDAT
     D tmpRC           S             10I 0 inz                                                RADDAT
     D toFile          S                   like(ifs_path_t ) inz                              RADDAT
     D toDirectory     S                   like(ifs_path_t ) inz                              RADDAT
     D toPath          S                   like(ifs_path_t ) inz                              RADDAT
     D cmd             S          10240A   varying           inz                              RADDAT
     *                                                                                       RADDAT
     *  stat() result data structure                                                         RADDAT
     D st_stat         DS                  likeds(st_stat_t) inz                              RADDAT
     *                                                                                       RADDAT
     *  The CPY command                                                                      RADDAT
     D CMD_CPY         C                   'CPY OBJ(''%OBJ%'') +                              RADDAT
     D                                          TOOBJ(''%TOOBJ%'')'                           RADDAT
     *                                                                                       RADDAT
CPY  /COPY QIFS2,IFS1011                         Directory '&1' does not exist.             RADDAT
CPY  /COPY QIFS2,IFS1012                         File '&1' does not exist.                  RADDAT
CPY  /COPY QIFS2,IFS1013                         File '&1' already exits.                   RADDAT
CPY  /COPY QIFS2,IFS1040                         Failed to copy file '&1' to '&2'.          RADDAT
CPY  /COPY QIFS2,IFS1041                         Options APPEND and REPLACE cannot be ...   RADDAT
CPY  /COPY QIFS2,IFS1042                         Could not copy '&1' because it is not ...  RADDAT
CPY  /COPY QIFS2,IFS1045                         Failed to retrieve the CCSID of file ...   RADDAT
CPY  /COPY QIFS2,IFS1046                         Specified CCSID &2 is different from ...   RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         //Process optional parameters ...                                                 //RADDAT
         //... i_options                                                                   //RADDAT
 B01     if (%parms() >= p_options and %addr(i_options) <> *NULL);                          //RADDAT
            options = i_options;                                                            //RADDAT
 X01     else;                                                                              //RADDAT
            options = cIFS_COPY_FILE_DFT;                                                   //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         //... i_ccsid                                                                     //RADDAT
 B01     if (%parms() >= p_ccsid and %addr(i_ccsid) <> *NULL);                              //RADDAT
            ccsid = i_ccsid;                                                                //RADDAT
 X01     else;                                                                              //RADDAT
            ccsid = cIFS_COPY_FILE_CCSID_SAME;                                              //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         msg = AppMsg_new(cMsg_ID_OK);                                                      //RADDAT
                                                                                            //RADDAT
 B01     dou '1';                                                                           //RADDAT
                                                                                            //RADDAT
            //Ensure that APPEND and REPLACE are not specified together.                   //RADDAT
 B02        if (f_isBitOn(cIFS_COPY_FILE_APPEND : options) and
 B03            f_isBitOn(cIFS_COPY_FILE_REPLACE: options));                                //RADDAT
               clear IFS1041;                                                               //RADDAT
               Application_killWithMsg(AppMsg_newEscape('IFS1041': IFS1041));               //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            //If the FROM object is a directory, ...                                       //RADDAT
 B02        if (ifsDirectory_exist(i_fromPath));                                            //RADDAT
               //... then create an error message                                          //RADDAT
               clear IFS1042;                                                               //RADDAT
               IFS10421 = i_fromPath;                                                       //RADDAT
               msg = AppMsg_newEscape('IFS1042': IFS1042);                                  //RADDAT
               rc = cIFS_ERROR;                                                             //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            //If the file does not exist, ...                                              //RADDAT
 B02        if (not ifsFile_exist(i_fromPath));                                             //RADDAT
               //... then create an error message                                          //RADDAT
               clear IFS1012;                                                               //RADDAT
               IFS10121 = i_fromPath;                                                       //RADDAT
               msg = AppMsg_newEscape('IFS1012': IFS1012);                                  //RADDAT
               rc = cIFS_ERROR;                                                             //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            //Compute path of target file                                                  //RADDAT
 B02        if (ifsPath_isDirectory(i_toPath) or ifsDirectory_exist(i_toPath));             //RADDAT
               toFile      = ifsPath_getName(i_fromPath);                                   //RADDAT
               toDirectory = ifsDirectory_fixSyntax(i_toPath);                              //RADDAT
 X02        else;                                                                           //RADDAT
               toFile      = ifsPath_getName(i_toPath);                                     //RADDAT
               toDirectory = ifsPath_getDirectory(i_toPath);                                //RADDAT
 B03           if (toDirectory = '');                                                       //RADDAT
                  toDirectory = ifsPath_getDirectory(i_fromPath);                           //RADDAT
 E03           endif;                                                                       //RADDAT
 B03           if (toDirectory = '');                                                       //RADDAT
                  toDirectory = ifsDirectory_fixSyntax('.');                                //RADDAT
 E03           endif;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            toPath = ifsPath_fixSyntax(toDirectory + toFile);                               //RADDAT
                                                                                            //RADDAT
            //If the target file does already exist, ...                                   //RADDAT
            fileExist = ifsFile_exist(toPath);                                              //RADDAT
                                                                                            //RADDAT
            //... delete it or switch to append mode, if allowed                           //RADDAT
 B02        if (fileExist);                                                                 //RADDAT
 B03           if (f_isBitOn(cIFS_COPY_FILE_REPLACE: options));                             //RADDAT
 B04              if (ifsFile_delete(toPath: msg) = cIFS_ERROR);                            //RADDAT
                     rc = cIFS_ERROR;                                                       //RADDAT
                     leave;                                                                 //RADDAT
 E04              endif;                                                                    //RADDAT
 E03           endif;                                                                       //RADDAT
 B03           if (f_isBitOn(cIFS_COPY_FILE_APPEND: options));                              //RADDAT
                  appendFile = cTrue;                                                       //RADDAT
 E03           endif;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
 B02        if (not appendFile and ifsFile_exist(toPath));                                  //RADDAT
               //... then create error message                                             //RADDAT
               clear IFS1013;                                                               //RADDAT
               IFS10131 = toPath;                                                           //RADDAT
               msg = AppMsg_newEscape('IFS1013': IFS1013);                                  //RADDAT
               rc = cIFS_ERROR;                                                             //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            //Check CCSID if data is going to be added to the target file                  //RADDAT
 B02        if (appendFile and ccsid <> cIFS_COPY_FILE_CCSID_SAME);                         //RADDAT
 B03           if (stat(toPath: %addr(st_stat)) = RC_ERROR);                                //RADDAT
                  clear IFS1045;            //Failed to retrieve CCSID                     //RADDAT
                  IFS10451 = toPath;                                                        //RADDAT
                  IFS10452 = f_errno();                                                     //RADDAT
                  IFS10453 = f_strerror(f_errno());                                         //RADDAT
                  msg = AppMsg_newEscape('IFS1045': IFS1045);                               //RADDAT
                  rc = cIFS_ERROR;                                                          //RADDAT
                  leave;                                                                    //RADDAT
 E03           endif;                                                                       //RADDAT
 B03           if (ccsid <> st_stat.ccsid);                                                 //RADDAT
                  clear IFS1046;            //CCSIDs are not equal                         //RADDAT
                  IFS10461 = toPath;                                                        //RADDAT
                  IFS10462 = ccsid;                                                         //RADDAT
                  IFS10463 = st_stat.ccsid;                                                 //RADDAT
                  msg = AppMsg_newEscape('IFS1046': IFS1046);                               //RADDAT
                  rc = cIFS_ERROR;                                                          //RADDAT
                  leave;                                                                    //RADDAT
 E03           endif;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            //If the target directory does not exist, ...                                  //RADDAT
 B02        if (not ifsDirectory_exist(toDirectory));                                       //RADDAT
 B03           if (not f_isBitOn(cIFS_COPY_FILE_CREATE_DIRECTORY: options));                //RADDAT
                  //... then create error message                                          //RADDAT
                  clear IFS1011;                                                            //RADDAT
                  IFS10111 = toDirectory;                                                   //RADDAT
                  msg = AppMsg_newEscape('IFS1011': IFS1011);                               //RADDAT
                  rc = cIFS_ERROR;                                                          //RADDAT
                  leave;                                                                    //RADDAT
 E03           endif;                                                                       //RADDAT
                                                                                            //RADDAT
 B03           if (ifsDirectory_create(
                      toDirectory: cIFS_MKDIR_SUBDIR: *omit: msg) = cIFS_ERROR);
                  rc = cIFS_ERROR;                                                          //RADDAT
                  leave;                                                                    //RADDAT
 E03           endif;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            //Copy stream file                                                             //RADDAT
 B02        if (appendFile or ccsid <> cIFS_COPY_FILE_CCSID_SAME);                          //RADDAT
 B03           if (not copyFileCreateOrAppend(i_fromPath: toPath: ccsid: msg));             //RADDAT
                  Application_killWithMsg(msg);                                             //RADDAT
                  //rc = cIFS_ERROR;                                                       //RADDAT
                  //leave;                                                                 //RADDAT
 E03           endif;                                                                       //RADDAT
 X02        else;                                                                           //RADDAT
               cmd = f_replace('%OBJ%'  : i_fromPath: CMD_CPY);                             //RADDAT
               cmd = f_replace('%TOOBJ%': toPath    : cmd);                                 //RADDAT
                                                                                            //RADDAT
               //If we got an error, ...                                                   //RADDAT
 B03           if (not f_execute(cmd: cCMD_PRC_EXC_QCMDEXC: msg));                          //RADDAT
               //... then create error message                                             //RADDAT
                  clear IFS1040;                                                            //RADDAT
                  IFS10401 = i_fromPath;                                                    //RADDAT
                  IFS10402 = toPath;                                                        //RADDAT
                  IFS10403 = msg.ID;                                                        //RADDAT
                  IFS10404 = f_rtvMsgText(msg);                                             //RADDAT
                  msg = AppMsg_newEscape('IFS1040': IFS1040);                               //RADDAT
                  rc = cIFS_ERROR;                                                          //RADDAT
                  leave;                                                                    //RADDAT
 E03           endif;                                                                       //RADDAT
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
    P ifsFile_copy...                                                                        RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Sets the read/write pointer of an open stream file to a new position.                RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_hFile       - The handle of a file opened by ifsFile_open().                      RADDAT
     *   i_offset      - The new position of the read/write pointer.                         RADDAT
     *   i_whence      - The base position to count i_offset from:                           RADDAT
     *                   SEEK_SET       The start of the file.                               RADDAT
     *                   SEEK_CUR       The current file offset in the file.                 RADDAT
     *                   SEEK_END       The end of the file.                                 RADDAT
     *   o_msg         - Error message.                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   rc            - Returns the file size on success, else cIFS_ERROR.                  RADDAT
     *=========================================================================              RADDAT
    P ifsFile_seek...                                                                        RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsFile_seek...                                                                        RADDAT
     D                 PI            10I 0                                                    RADDAT
     D i_hFile                             const  like(ifs_hFile_t   )                        RADDAT
     D i_offset                      10I 0 const                                              RADDAT
     D i_whence                      10I 0 const                                              RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D newOffset       S             10I 0 inz                                                RADDAT
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_msg           C                   const(4)                                           RADDAT
     *                                                                                       RADDAT
     *  Fields for optional parameters                                                       RADDAT
     D msg             DS                  likeds(msg_t    ) inz                              RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     *                                                                                       RADDAT
     *  File handle                                                                          RADDAT
     D handle          DS                  likeds(handle_t ) based(pHandle)                   RADDAT
     *                                                                                       RADDAT
CPY  /COPY QIFS2,IFS1008                         Failed to set read/write offset of ...     RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         //Check assurances                                                                //RADDAT
         p_assert((i_whence = SEEK_SET)  or
                  (i_whence = SEEK_CUR)  or
                  (i_whence = SEEK_END)                                   :
                  'Invalid parameter for i_whence.'                       );                //RADDAT
                                                                                            //RADDAT
         //Get access to file handle date                                                  //RADDAT
         pHandle = HANDLE_getPointer(i_hFile);                                              //RADDAT
                                                                                            //RADDAT
         //Set the the new file offset                                                     //RADDAT
         newOffset = lseek(handle.hFileUnix: i_offset: i_whence);                           //RADDAT
                                                                                            //RADDAT
         //If we got an error message, ...                                                 //RADDAT
 B01     if (newOffset = RC_ERROR);                                                         //RADDAT
            //... create error message                                                     //RADDAT
            clear IFS1008;                                                                  //RADDAT
            IFS10081 = handle.path;                                                         //RADDAT
            IFS10082 = f_errno();                                                           //RADDAT
            IFS10083 = f_strerror(f_errno());                                               //RADDAT
            IFS10084 = i_offset;                                                            //RADDAT
            IFS10085 = i_whence;                                                            //RADDAT
            msg = AppMsg_newEscape('IFS1008': IFS1008);                                     //RADDAT
            newOffset = cIFS_ERROR;                                                         //RADDAT
 X01     else;                                                                              //RADDAT
            //... else create OK message                                                   //RADDAT
            msg = AppMsg_new(cMsg_ID_OK);                                                   //RADDAT
            newOffset = cIFS_OK;                                                            //RADDAT
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
         return newOffset;                                                                  //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P ifsFile_seek...                                                                        RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Reads data from a given stream file.                                                 RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_hFile       - The handle of a file opened by ifsFile_open().                      RADDAT
     *   i_pBuffer     - A pointer to the input data.                                        RADDAT
     *   i_length      - The length of the buffer.                                           RADDAT
     *   o_msg         - Error message.                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   rc            - Returns the number of bytes that were red from                      RADDAT
     *                   the IFS file or cIFS_ERROR.                                         RADDAT
     *=========================================================================              RADDAT
    P ifsFile_read...                                                                        RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsFile_read...                                                                        RADDAT
     D                 PI            10I 0                                                    RADDAT
     D i_hFile                             const  like(ifs_hFile_t   )                        RADDAT
     D i_pBuffer                       *   const                                              RADDAT
     D i_length                      10I 0 const                                              RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D bytesRed        S             10I 0 inz                                                RADDAT
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_msg           C                   const(4)                                           RADDAT
     *                                                                                       RADDAT
     *  Fields for optional parameters                                                       RADDAT
     D msg             DS                  likeds(msg_t    ) inz                              RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D tmpRC           S             10I 0 inz                                                RADDAT
     *                                                                                       RADDAT
     *  File handle                                                                          RADDAT
     D handle          DS                  likeds(handle_t ) based(pHandle)                   RADDAT
     *                                                                                       RADDAT
CPY  /COPY QIFS2,IFS1004                         Failed to read data from file '&1'.        RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         //Get access to file handle date                                                  //RADDAT
         pHandle = HANDLE_getPointer(i_hFile);                                              //RADDAT
                                                                                            //RADDAT
         //Read data from the IFS file                                                     //RADDAT
         tmpRC = read(handle.hFileUnix: i_pBuffer: i_length);                               //RADDAT
                                                                                            //RADDAT
         //If we got an error ...                                                          //RADDAT
 B01     if (tmpRC = RC_ERROR);                                                             //RADDAT
            //... then create error message                                                //RADDAT
            clear IFS1004;                                                                  //RADDAT
            IFS10041 = handle.path;                                                         //RADDAT
            IFS10042 = f_errno();                                                           //RADDAT
            IFS10043 = f_strerror(f_errno());                                               //RADDAT
            msg = AppMsg_newEscape('IFS1004': IFS1004);                                     //RADDAT
            bytesRed = cIFS_ERROR;                                                          //RADDAT
 X01     else;                                                                              //RADDAT
            //clear message                                                                //RADDAT
            msg = AppMsg_new(cMsg_ID_OK);                                                   //RADDAT
            bytesRed = tmpRC;                                                               //RADDAT
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
         return bytesRed;                                                                   //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P ifsFile_read...                                                                        RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Writes data to a given stream file.                                                  RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_hFile       - The handle of a file opened by ifsFile_open().                      RADDAT
     *   i_pBuffer     - A pointer to the data to write to the IFS file.                     RADDAT
     *   i_length      - The length of the data or 0 is the data is a                        RADDAT
     *                   null-terminated string.                                             RADDAT
     *   o_msg         - Error message.                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   rc            - Returns the number of bytes that have been written                  RADDAT
     *                   to the stream file on success, else cIFS_ERROR.                     RADDAT
     *=========================================================================              RADDAT
    P ifsFile_write...                                                                       RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsFile_write...                                                                       RADDAT
     D                 PI            10I 0                                                    RADDAT
     D i_hFile                             const  like(ifs_hFile_t   )                        RADDAT
     D i_pBuffer                       *   const  options(*string)                            RADDAT
     D i_length                      10I 0 const                                              RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D bytesWritten    S             10I 0 inz                                                RADDAT
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_msg           C                   const(4)                                           RADDAT
     *                                                                                       RADDAT
     *  Fields for optional parameters                                                       RADDAT
     D msg             DS                  likeds(msg_t    ) inz                              RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D length          S             10I 0 inz                                                RADDAT
     D tmpRC           S             10I 0 inz                                                RADDAT
     *                                                                                       RADDAT
     *  File handle                                                                          RADDAT
     D handle          DS                  likeds(handle_t ) based(pHandle)                   RADDAT
     *                                                                                       RADDAT
CPY  /COPY QIFS2,IFS1002                         Failed to write data to file '&1'.         RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         //Get access to file handle date                                                  //RADDAT
         pHandle = HANDLE_getPointer(i_hFile);                                              //RADDAT
                                                                                            //RADDAT
         //Get the buffer length if the length is specified as -1                          //RADDAT
 B01     if (i_length = 0);                                                                 //RADDAT
            length = strlen(i_pBuffer);                                                     //RADDAT
 X01     else;                                                                              //RADDAT
            length = i_length;                                                              //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         //Write data to IFS file                                                          //RADDAT
         tmpRC = write(handle.hFileUnix: i_pBuffer: length);                                //RADDAT
                                                                                            //RADDAT
         //If we got an error                                                              //RADDAT
 B01     if (tmpRC = RC_ERROR);                                                             //RADDAT
            //... then create error message                                                //RADDAT
            clear IFS1002;                                                                  //RADDAT
            IFS10021 = handle.path;                                                         //RADDAT
            IFS10022 = f_errno();                                                           //RADDAT
            IFS10023 = f_strerror(f_errno());                                               //RADDAT
            msg = AppMsg_newEscape('IFS1002': IFS1002);                                     //RADDAT
            bytesWritten = cIFS_ERROR;                                                      //RADDAT
 X01     else;                                                                              //RADDAT
            //clear message                                                                //RADDAT
            msg = AppMsg_new(cMsg_ID_OK);                                                   //RADDAT
            bytesWritten = tmpRC;                                                           //RADDAT
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
         return bytesWritten;                                                               //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P ifsFile_write...                                                                       RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Reads a line from a given stream file.                                               RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_hFile       - The handle of a file opened by ifsFile_open().                      RADDAT
     *   i_pBuffer     - A pointer to the input data.                                        RADDAT
     *   i_length      - The length of the buffer.                                           RADDAT
     *   i_EOLChar     - End-Of-Line character string.                                       RADDAT
     *                   Default:        cIFS_EOL_CRLF                                       RADDAT
     *                   cIFS_EOL_CRLF - Ascii 0D+0A, typically used                         RADDAT
     *                                   by DOS and Windows systems.                         RADDAT
     *                   cIFS_EOL_LF   - Ascii 0A, typically used                            RADDAT
     *                                   by Unix systems.                                    RADDAT
     *                   cIFS_EOL_CR   - Ascii 0D, typically used                            RADDAT
     *                                   by Mac systems.                                     RADDAT
     *   o_msg         - Error message.                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   rc            - Returns the number of bytes that were red from                      RADDAT
     *                   the file or cIFS_ERROR. Returns cIFS_EOL                            RADDAT
     *                   in case of EOF.                                                     RADDAT
     *                                                                                       RADDAT
     *  Comments:                                                                            RADDAT
     *   A line is considered as a series of bytes terminated by an                          RADDAT
     *   End-Of-Line character. The EOL-character is not added to the                        RADDAT
     *   buffer addressed by i_pBuffer.                                                      RADDAT
     *   By default der ifsFile_readLine() procedure uses CR+LF as                           RADDAT
     *   the EOL-characters. Since DOS/Windows, Unix and Mac uses different                  RADDAT
     *   EOL-characters, the EOL-character to be use can be specified at                     RADDAT
     *   i_EOLChar.                                                                          RADDAT
     *   Notice that beside the predefined constants you can use any other                   RADDAT
     *   character or character string up to 32 byte as the EOL-character.                   RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
    P ifsFile_readLine...                                                                    RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsFile_readLine...                                                                    RADDAT
     D                 PI            10I 0                                                    RADDAT
     D i_hFile                             const  like(ifs_hFile_t   )                        RADDAT
     D i_pBuffer                       *   const                                              RADDAT
     D i_length                      10I 0 const                                              RADDAT
     D i_EOLChar                           const  like(ifs_EOLChar_t )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D bytesRed        S             10I 0 inz                                                RADDAT
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_EOLChar       C                   const(4)                                           RADDAT
     D p_msg           C                   const(5)                                           RADDAT
     *                                                                                       RADDAT
     *  Fields for optional parameters                                                       RADDAT
     D eolChar         S                   like(i_EOLChar  ) inz                              RADDAT
     D msg             DS                  likeds(msg_t    ) inz                              RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D bytesLeft       S             10I 0 inz                                                RADDAT
     D bytesTotal      S             10I 0 inz                                                RADDAT
     D bytesCpy        S             10I 0 inz                                                RADDAT
     D a1ByteBuffer    S              1A   inz                                                RADDAT
     D pBuffer         S               *   inz                                                RADDAT
     D ofsOutBuffer    S                   like(i_length     ) inz(0)                         RADDAT
     *                                                                                       RADDAT
     D EOLBuffer       DS                  qualified                                          RADDAT
     D  mustFlush                      N   inz(cFalse)                                        RADDAT
     D  data                               like(ifs_EOLChar_t) inz                            RADDAT
     *                                                                                       RADDAT
     *  File handle                                                                          RADDAT
     D handle          DS                  likeds(handle_t ) based(pHandle)                   RADDAT
     *                                                                                       RADDAT
CPY  /COPY QIFS2,IFS1016                         Buffer overflow while reading from ...     RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         //Get optional parameters ...                                                     //RADDAT
         //... EOL-character (string)                                                      //RADDAT
 B01     if (%parms() >= p_EOLChar and %addr(i_EOLChar) <> *NULL);                          //RADDAT
            EOLChar = i_EOLChar;                                                            //RADDAT
 X01     else;                                                                              //RADDAT
            EOLChar = cIFS_EOL_CRLF;                                                        //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         //Get access to file handle date                                                  //RADDAT
         pHandle = HANDLE_getPointer(i_hFile);                                              //RADDAT
                                                                                            //RADDAT
         //Initialized the remaining size of the output buffer                             //RADDAT
         bytesLeft = i_length;                                                              //RADDAT
                                                                                            //RADDAT
         //Read until EOL-charcater                                                        //RADDAT
 B01     dou (EOLbuffer.data = EOLChar);                                                    //RADDAT
                                                                                            //RADDAT
            //Add bytes red to output buffer                                               //RADDAT
 B02        dow (bytesTotal > 0 and bytesLeft > 0);                                         //RADDAT
                                                                                            //RADDAT
 B03           if (EOLBuffer.mustFlush);                                                    //RADDAT
                  pBuffer  = %addr(EOLBuffer.data) + 2;                                     //RADDAT
 B04              if (%len(EOLBuffer.data) > bytesLeft);                                    //RADDAT
                     bytesCpy = bytesLeft;                                                  //RADDAT
 X04              else;                                                                     //RADDAT
                     bytesCpy = %len(EOLBuffer.data);                                       //RADDAT
 E04              endif;                                                                    //RADDAT
 X03           else;                                                                        //RADDAT
                  pBuffer  = %addr(a1ByteBuffer);                                           //RADDAT
                  bytesCpy = 1;                                                             //RADDAT
 E03           endif;                                                                       //RADDAT
                                                                                            //RADDAT
               memcpy(i_pBuffer + ofsOutBuffer: pBuffer: bytesCpy);                         //RADDAT
               ofsOutBuffer = ofsOutBuffer + bytesCpy;                                      //RADDAT
               bytesRed   = bytesRed + bytesCpy;                                            //RADDAT
               bytesTotal = bytesTotal - bytesCpy;                                          //RADDAT
               bytesLeft  = bytesLeft  - bytesCpy;                                          //RADDAT
                                                                                            //RADDAT
 B03           if (EOLBuffer.mustFlush);                                                    //RADDAT
                  EOLBuffer.data = '';                                                      //RADDAT
                  EOLBuffer.mustFlush = cFalse;                                             //RADDAT
 E03           endif;                                                                       //RADDAT
                                                                                            //RADDAT
 E02        enddo;                                                                          //RADDAT
                                                                                            //RADDAT
            //Check the number of bytes that could not be                                  //RADDAT
            //copied to the output buffer                                                  //RADDAT
 B02        if (bytesTotal > 0);                                                            //RADDAT
               //... create error message on buffer overflow                               //RADDAT
               clear IFS1016;                                                               //RADDAT
               IFS10161 = handle.path;                                                      //RADDAT
               IFS10162 = i_length;                                                         //RADDAT
               msg = AppMsg_newEscape('IFS1016': IFS1016);                                  //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            //Read data from the stream file                                               //RADDAT
            bytesTotal = ifsFile_read(i_hFile: %addr(a1ByteBuffer): 1: msg);                //RADDAT
                                                                                            //RADDAT
            //If we got an error ...                                                       //RADDAT
 B02        if (msg.ID <> cMSG_ID_OK);                                                      //RADDAT
               //... return error message                                                  //RADDAT
               bytesRed = -1;                                                               //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            //If we reached EOF ...                                                        //RADDAT
 B02        if (bytesTotal = 0);                                                            //RADDAT
               //... cancel loop                                                           //RADDAT
 B03           if (bytesRed = 0);                                                           //RADDAT
                  bytesRed = cIFS_EOF;                                                      //RADDAT
 E03           endif;                                                                       //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            //Append the byte we just red to the EOL buffer                                //RADDAT
            //in case the byte red matches the next byte we                                //RADDAT
            //expect:                                                                      //RADDAT
 B02        if (a1ByteBuffer = %subst(EOLChar: %len(EOLBuffer.data) + 1: 1));               //RADDAT
               EOLBuffer.data = EOLBuffer.data + a1ByteBuffer;                              //RADDAT
               bytesTotal = 0;                                                              //RADDAT
 X02        else;                                                                           //RADDAT
 B03           if (%len(EOLBuffer.data) > 0);                                               //RADDAT
                  EOLBuffer.mustFlush = cTrue;                                              //RADDAT
                  bytesTotal = bytesTotal + %len(EOLBuffer.data);                           //RADDAT
 E03           endif;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
 E01     enddo;                                                                             //RADDAT
                                                                                            //RADDAT
         //Strip the EOL-character (string) from the output buffer                         //RADDAT
         //in case we left the loop due to EOL condition:                                  //RADDAT
         //(Remind that the last byte of the EOL-character was                             //RADDAT
         // not yet added to the output buffer!)                                           //RADDAT
 B01     //if (EOLbuffer.data = EOLChar);                                                  //RADDAT
         //   bytesRed = bytesRed - (%len(EOLChar) - 1);                                   //RADDAT
 E01     //endif;                                                                          //RADDAT
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
         return bytesRed;                                                                   //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P ifsFile_readLine...                                                                    RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Writes line to a given stream file.                                                  RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_hFile       - The handle of a file opened by ifsFile_open().                      RADDAT
     *   i_pBuffer     - A pointer to the data to write to the IFS file.                     RADDAT
     *   i_length      - The length of the data or 0 is the data is a                        RADDAT
     *                   null-terminated string.                                             RADDAT
     *   i_EOLChar     - End-Of-Line character string.                                       RADDAT
     *                   Default:        cIFS_EOL_CRLF                                       RADDAT
     *                   cIFS_EOL_CRLF - Ascii 0D+0A, typically used                         RADDAT
     *                                   by DOS and Windows systems.                         RADDAT
     *                   cIFS_EOL_LF   - Ascii 0A, typically used                            RADDAT
     *                                   by Unix systems.                                    RADDAT
     *                   cIFS_EOL_CR   - Ascii 0D, typically used                            RADDAT
     *                                   by Mac systems.                                     RADDAT
     *   o_msg         - Error message.                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   rc            - Returns the number of bytes that were written to                    RADDAT
     *                   the IFS file or cIFS_ERROR.                                         RADDAT
     *                                                                                       RADDAT
     *  Comments:                                                                            RADDAT
     *   A line is considered as a series of bytes terminated by an                          RADDAT
     *   End-Of-Line character. The EOL-character must not be included in                    RADDAT
     *   the buffer addressed by i_pBuffer. It is automatically added.                       RADDAT
     *   By default the ifsFile_writeLine() procedure uses CR+LF as                          RADDAT
     *   the EOL-characters. Since DOS/Windows, Unix and Mac uses different                  RADDAT
     *   EOL-characters, the EOL-character to be use can be specified at                     RADDAT
     *   i_EOLChar.                                                                          RADDAT
     *   Notice that beside the predefined constants you can use any other                   RADDAT
     *   character or character string up to 32 byte as the EOL-character.                   RADDAT
     *                                                                                       RADDAT
     *  Hint:                                                                                RADDAT
     *   Usually ifsFile_writeLine() uses separate write operation to                        RADDAT
     *   write the data and the end-of-line characters to the file. If                       RADDAT
     *   a file is shared with other writers, data and EOL characters                        RADDAT
     *   have to be written in a single, atomic operation. Otherwise                         RADDAT
     *   the output data can get mixed up with the data of other writers.                    RADDAT
     *   In those cases ifsFile_writeLine() uses a temporary buffer to                       RADDAT
     *   ensure that the data and the EOL characters are written at once.                    RADDAT
     *   Of course that reduces performance.                                                 RADDAT
     *   In order to gain better performance you may add the EOL characters                  RADDAT
     *   manually before calling ifsFile_writeLine(). In that case specify                   RADDAT
     *   and empty string for the EOL characters at ifsFile_writeLine().                     RADDAT
     *                                                                                       RADDAT
     *   Sample:                                                                             RADDAT
     *                                                                                       RADDAT
     *     data = 'Hello World' + cIFS_EOL_CRLF;                                             RADDAT
     *     rc = ifsFile_writeLine(hFile                                                      RADDAT
     *                            : %addr(data)                                              RADDAT
     *                            : %len(data)                                               RADDAT
     *                            : ''                                                       RADDAT
     *                            : msg);                                                    RADDAT
     *     if (rc > 0);                                                                      RADDAT
     *        numBytes = rc - %len(cIFS_EOL_CRLF);                                           RADDAT
     *     endif;                                                                            RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
    P ifsFile_writeLine...                                                                   RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsFile_writeLine...                                                                   RADDAT
     D                 PI            10I 0                                                    RADDAT
     D i_hFile                             const  like(ifs_hFile_t   )                        RADDAT
     D i_pBuffer                       *   const  options(*string)                            RADDAT
     D i_length                      10I 0 const                                              RADDAT
     D i_EOLChar                           const  like(ifs_EOLChar_t )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D bytesWritten    S             10I 0 inz                                                RADDAT
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_EOLChar       C                   const(4)                                           RADDAT
     D p_msg           C                   const(5)                                           RADDAT
     *                                                                                       RADDAT
     *  Fields for optional parameters                                                       RADDAT
     D eolChar         S                   like(i_EOLChar  ) inz                              RADDAT
     D msg             DS                  likeds(msg_t    ) inz                              RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D length          S             10I 0 inz                                                RADDAT
     D lengthEOL       S             10I 0 inz                                                RADDAT
     D startPos        S             10I 0 inz                                                RADDAT
     D numBytes        S             10I 0 inz                                                RADDAT
     D newSize         S             10I 0 inz                                                RADDAT
     D EOLBuffer       S             32A   based(pEOLBuffer)                                  RADDAT
     D pBuffer         S               *   inz                                                RADDAT
     D x               S             10I 0 inz                                                RADDAT
     *                                                                                       RADDAT
     *  File handle                                                                          RADDAT
     D handle          DS                  likeds(handle_t ) based(pHandle)                   RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         //Get optional parameters ...                                                     //RADDAT
         //... EOL-character (string)                                                      //RADDAT
 B01     if (%parms() >= p_EOLChar and %addr(i_EOLChar) <> *NULL);                          //RADDAT
            EOLChar = i_EOLChar;                                                            //RADDAT
 X01     else;                                                                              //RADDAT
            EOLChar = cIFS_EOL_CRLF;                                                        //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         //Get access to file handle date                                                  //RADDAT
         pHandle = HANDLE_getPointer(i_hFile);                                              //RADDAT
                                                                                            //RADDAT
         //Get the buffer length if the length is specified as 0                           //RADDAT
 B01     if (i_length = 0);                                                                 //RADDAT
            length = strlen(i_pBuffer);                                                     //RADDAT
 X01     else;                                                                              //RADDAT
            length = i_length;                                                              //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         //Use temporary buffer when file is shared with other writers                     //RADDAT
 B01     if (%len(EOLChar) > 0 and handle.useWriteBuffer);                                  //RADDAT
                                                                                            //RADDAT
            //Check buffer size, reallocate buffer if necessary                            //RADDAT
            newSize = length + %len(EOLChar);                                               //RADDAT
            pBuffer = checkHandleBufferSizeAndReallocate(handle.writeBuffer
                                                         : newSize);                        //RADDAT
                                                                                            //RADDAT
            //Copy input buffer to temporary write buffer                                  //RADDAT
            memcpy(pBuffer: i_pBuffer: length);                                             //RADDAT
                                                                                            //RADDAT
            //Add EOL-character (string)                                                   //RADDAT
            pEOLBuffer = pBuffer + length;
            %subst(EOLBuffer: 1: %len(EOLChar)) = EOLChar;
                                                                                            //RADDAT
            //Adjust length of buffer                                                      //RADDAT
            length = newSize;                                                               //RADDAT
                                                                                            //RADDAT
            //Clear EOL characters to avoid to append them twice                           //RADDAT
            //but remined its length in order to return the correct                        //RADDAT
            //number of bytes that have been written to the file.                          //RADDAT
            lengthEOL = %len(EOLChar);                                                      //RADDAT
            EOLChar   = '';                                                                 //RADDAT
                                                                                            //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         //Write data to IFS file                                                          //RADDAT
 B01     if (pBuffer <> *NULL);                                                             //RADDAT
            bytesWritten = ifsFile_write(i_hFile: pBuffer: length: msg);                    //RADDAT
 X01     else;                                                                              //RADDAT
            bytesWritten = ifsFile_write(i_hFile: i_pBuffer: length: msg);                  //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
 B01     if (bytesWritten > 0);                                                             //RADDAT
            bytesWritten = bytesWritten - lengthEOL;                                        //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         //Add EOL-character (string)                                                      //RADDAT
 B01     if (EOLChar <> '' and msg.ID = cMSG_ID_OK);                                        //RADDAT
            numBytes = ifsFile_write(i_hFile: EOLChar: %len(EOLChar): msg);                 //RADDAT
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
         return bytesWritten;                                                               //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P ifsFile_writeLine...                                                                   RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Returns the size on a given stream file.                                             RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_path        - The path name of a given IFS file.                                  RADDAT
     *   o_msg         - Error message.                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   fileSize      - Size of the stream file on success, else cIFS_ERROR.                RADDAT
     *=========================================================================              RADDAT
    P ifsFile_getSize...                                                                     RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsFile_getSize...                                                                     RADDAT
     D                 PI            10I 0                                                    RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D fileSize        S             10I 0 inz                                                RADDAT
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_msg           C                   const(2)                                           RADDAT
     *                                                                                       RADDAT
     *  Fields for optional parameters                                                       RADDAT
     D msg             DS                  likeds(msg_t    ) inz                              RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D tmpRC           S             10I 0 inz                                                RADDAT
     *                                                                                       RADDAT
     *  stat() result data structure                                                         RADDAT
     D st_stat         DS                  likeds(st_stat_t) inz                              RADDAT
     *                                                                                       RADDAT
CPY  /COPY QIFS2,IFS1006                         Failed to retrieve the size of file '&1'.  RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         //Get the size of the stream file                                                 //RADDAT
         tmpRC = stat(ifsPath_fixSyntax(i_path): %addr(st_stat));                           //RADDAT
                                                                                            //RADDAT
 B01     if (tmpRC = RC_ERROR);                                                             //RADDAT
            clear IFS1006;                                                                  //RADDAT
            IFS10061 = i_path;                                                              //RADDAT
            IFS10062 = f_errno();                                                           //RADDAT
            IFS10063 = f_strerror(f_errno());                                               //RADDAT
            msg = AppMsg_newEscape('IFS1006': IFS1006);                                     //RADDAT
            fileSize = cIFS_ERROR;                                                          //RADDAT
 X01     else;                                                                              //RADDAT
            msg = AppMsg_new(cMsg_ID_OK);                                                   //RADDAT
            fileSize = st_stat.size;                                                        //RADDAT
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
         return fileSize;                                                                   //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P ifsFile_getSize...                                                                     RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Returns the size of the file referenced by a given file handle.                      RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_hFile       - The handle of a file opened by ifsFile_open().                      RADDAT
     *   o_msg         - Error message.                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   fileSize      - Size of the stream file on success, else cIFS_ERROR.                RADDAT
     *=========================================================================              RADDAT
    P ifsFile_getSizeH...                                                                    RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsFile_getSizeH...                                                                    RADDAT
     D                 PI            10I 0                                                    RADDAT
     D i_hFile                             const  like(ifs_hFile_t   )                        RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D fileSize        S             10I 0 inz                                                RADDAT
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_msg           C                   const(2)                                           RADDAT
     *                                                                                       RADDAT
     *  Fields for optional parameters                                                       RADDAT
     D msg             DS                  likeds(msg_t    ) inz                              RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D tmpRC           S             10I 0 inz                                                RADDAT
     *                                                                                       RADDAT
     *  stat() result data structure                                                         RADDAT
     D st_stat         DS                  likeds(st_stat_t) inz                              RADDAT
     *                                                                                       RADDAT
     *  File handle                                                                          RADDAT
     D handle          DS                  likeds(handle_t ) based(pHandle)                   RADDAT
     *                                                                                       RADDAT
CPY  /COPY QIFS2,IFS1006                         Failed to retrieve the size of file '&1'.  RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         //Get access to file handle date                                                  //RADDAT
         pHandle = HANDLE_getPointer(i_hFile);                                              //RADDAT
                                                                                            //RADDAT
         //Get the size of the stream file                                                 //RADDAT
         tmpRC = fstat(handle.hFileUnix: st_stat);                                          //RADDAT
                                                                                            //RADDAT
 B01     if (tmpRC = RC_ERROR);                                                             //RADDAT
            clear IFS1006;                                                                  //RADDAT
            IFS10061 = handle.path;                                                         //RADDAT
            IFS10062 = f_errno();                                                           //RADDAT
            IFS10063 = f_strerror(f_errno());                                               //RADDAT
            msg = AppMsg_newEscape('IFS1006': IFS1006);                                     //RADDAT
            fileSize = cIFS_ERROR;                                                          //RADDAT
 X01     else;                                                                              //RADDAT
            msg = AppMsg_new(cMsg_ID_OK);                                                   //RADDAT
            fileSize = st_stat.size;                                                        //RADDAT
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
         return fileSize;                                                                   //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P ifsFile_getSizeH...                                                                    RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Changes the size on a given stream file.                                             RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_path        - The path name of a given IFS file.                                  RADDAT
     *   o_msg         - Error message.                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   fileSize      - New size of the stream file on success, else                        RADDAT
     *                   cIFS_ERROR.                                                         RADDAT
     *=========================================================================              RADDAT
    P ifsFile_setSize...                                                                     RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsFile_setSize...                                                                     RADDAT
     D                 PI            10I 0                                                    RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D fileSize        S             10I 0 inz                                                RADDAT
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_msg           C                   const(2)                                           RADDAT
     *                                                                                       RADDAT
     *  Fields for optional parameters                                                       RADDAT
     D msg             DS                  likeds(msg_t    ) inz                              RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D tmpRC           S             10I 0 inz                                                RADDAT
     *                                                                                       RADDAT
CPY  /COPY QIFS2,IFS1007                         Failed to change size of file '&1'.        RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         p_assert(cFalse: f_this() + ': not yet implemented');                              //RADDAT
                                                                                            //RADDAT
 B01     if (tmpRC = RC_ERROR);                                                             //RADDAT
            clear IFS1007;                                                                  //RADDAT
            IFS10071 = i_path;                                                              //RADDAT
            IFS10072 = f_errno();                                                           //RADDAT
            IFS10073 = f_strerror(f_errno());                                               //RADDAT
            msg = AppMsg_newEscape('IFS1007': IFS1007);                                     //RADDAT
            fileSize = cIFS_ERROR;                                                          //RADDAT
 X01     else;                                                                              //RADDAT
            msg = AppMsg_new(cMsg_ID_OK);                                                   //RADDAT
            fileSize = tmpRC;                                                               //RADDAT
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
         return fileSize;                                                                   //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P ifsFile_setSize...                                                                     RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Changes the size of the file referenced by a given file handle.                      RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_hFile       - The handle of a file opened by ifsFile_open().                      RADDAT
     *   i_newSize     - The new size of the IFS file.                                       RADDAT
     *   o_msg         - Error message.                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   fileSize      - New size of the stream file on success, else                        RADDAT
     *                   cIFS_ERROR.                                                         RADDAT
     *=========================================================================              RADDAT
    P ifsFile_setSizeH...                                                                    RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsFile_setSizeH...                                                                    RADDAT
     D                 PI            10I 0                                                    RADDAT
     D i_hFile                             const  like(ifs_hFile_t   )                        RADDAT
     D i_newSize                     10I 0 const                                              RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D fileSize        S             10I 0 inz                                                RADDAT
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_msg           C                   const(3)                                           RADDAT
     *                                                                                       RADDAT
     *  Fields for optional parameters                                                       RADDAT
     D msg             DS                  likeds(msg_t    ) inz                              RADDAT
     *                                                                                       RADDAT
     *  Local fields                                                                         RADDAT
     D tmpRC           S             10I 0 inz                                                RADDAT
     *                                                                                       RADDAT
     *  File handle                                                                          RADDAT
     D handle          DS                  likeds(handle_t ) based(pHandle)                   RADDAT
     *                                                                                       RADDAT
CPY  /COPY QIFS2,IFS1007                         Failed to change size of file '&1'.        RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         //Get access to file handle date                                                  //RADDAT
         pHandle = HANDLE_getPointer(i_hFile);                                              //RADDAT
                                                                                            //RADDAT
         //Set the new size of the IFS file                                                //RADDAT
         tmpRC = ftruncate(i_hFile: i_newSize);                                             //RADDAT
                                                                                            //RADDAT
         //If we got an error, ...                                                         //RADDAT
 B01     if (tmpRC = RC_ERROR);                                                             //RADDAT
            clear IFS1007;                                                                  //RADDAT
            IFS10071 = handle.path;                                                         //RADDAT
            IFS10072 = f_errno();                                                           //RADDAT
            IFS10073 = f_strerror(f_errno());                                               //RADDAT
            msg = AppMsg_newEscape('IFS1007': IFS1007);                                     //RADDAT
            fileSize = cIFS_ERROR;                                                          //RADDAT
 X01     else;                                                                              //RADDAT
            msg = AppMsg_new(cMsg_ID_OK);                                                   //RADDAT
            fileSize = tmpRC;                                                               //RADDAT
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
         return fileSize;                                                                   //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P ifsFile_setSizeH...                                                                    RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Returns the creation timestamp of a given stream file.                               RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_path        - The path name of a given stream file.                               RADDAT
     *   o_msg         - Error message.                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   crtTime       - Timestamp the file was created on success, else                     RADDAT
     *                   *LOVAL.                                                             RADDAT
     *=========================================================================              RADDAT
    P ifsFile_getCreationTime...                                                             RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsFile_getCreationTime...                                                             RADDAT
     D                 PI              Z                                                      RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)
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
CPY  /COPY QIFS2,IFS1021                         Failed to retrieve the timestamp the ...   RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         //Retrieve file creation time ...                                                 //RADDAT
         tmpRC = FileAttr_getTime(ifsPath_fixSyntax(i_path)
                                  : QP0L_ATTR_CREATE_TIME: tmpCrtTime);                     //RADDAT
 B01     if (tmpRC = RC_ERROR);                                                             //RADDAT
            clear IFS1021;                                                                  //RADDAT
            IFS10211 = i_path;                                                              //RADDAT
            IFS10212 = f_errno();                                                           //RADDAT
            IFS10213 = f_strerror(f_errno());                                               //RADDAT
            msg = AppMsg_newEscape('IFS1021': IFS1021);                                     //RADDAT
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
    P ifsFile_getCreationTime...                                                             RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Returns the timestamp the stream file data was last changed.                         RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_path        - The path name of a given stream file.                               RADDAT
     *   o_msg         - Error message.                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   chgTime       - Timestamp the stream file data was last changed                     RADDAT
     *                   on success, else *LOVAL;                                            RADDAT
     *=========================================================================              RADDAT
    P ifsFile_getDataChangeTime...                                                           RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsFile_getDataChangeTime...                                                           RADDAT
     D                 PI              Z                                                      RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)
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
CPY  /COPY QIFS2,IFS1022                         Failed to retrieve the timestamp the ...   RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         //Retrieve the time the file data was last changed ...                            //RADDAT
         tmpRC = FileAttr_getTime(ifsPath_fixSyntax(i_path)
                                  : QP0L_ATTR_MODIFY_TIME: tmpChgTime);                     //RADDAT
 B01     if (tmpRC = RC_ERROR);                                                             //RADDAT
            clear IFS1022;                                                                  //RADDAT
            IFS10221 = i_path;                                                              //RADDAT
            IFS10222 = f_errno();                                                           //RADDAT
            IFS10223 = f_strerror(f_errno());                                               //RADDAT
            msg = AppMsg_newEscape('IFS1022': IFS1022);                                     //RADDAT
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
    P ifsFile_getDataChangeTime...                                                           RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Returns the file ID that uniquely identifies a given stream file.                    RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_path        - The name of a given stream file.                                    RADDAT
     *   o_msg         - Error message.                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   fileID        - Returns the file ID on success, else cIFS_ERROR.                    RADDAT
     *=========================================================================              RADDAT
    P ifsFile_getUniqueID...                                                                 RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsFile_getUniqueID...                                                                 RADDAT
     D                 PI                         likeds(ifs_uniqueFileID_t)                  RADDAT
     D i_path                              const  like(ifs_path_t          )                  RADDAT
     D                                            options(*varsize)
     D o_msg                                      like(msg_t               )                  RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D fileID          DS                  likeds(ifs_uniqueFileID_t) inz                     RADDAT
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_msg           C                   const(2)                                           RADDAT
     *                                                                                       RADDAT
     *  Fields for optional parameters                                                       RADDAT
     D msg             DS                  likeds(msg_t    ) inz                              RADDAT
     *                                                                                       RADDAT
     *  Local fields                                                                         RADDAT
     D tmpRC           S             10I 0 inz                                                RADDAT
     *                                                                                       RADDAT
     *  stat() result data structure                                                         RADDAT
     D st_stat         DS                  likeds(st_stat_t) inz                              RADDAT
     *                                                                                       RADDAT
CPY  /COPY QIFS2,IFS1028                         Failed to retrieve the unique file ID ...  RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         //Get the file ID of the stream file                                              //RADDAT
         tmpRC = stat(ifsPath_fixSyntax(i_path): %addr(st_stat));                           //RADDAT
                                                                                            //RADDAT
 B01     if (tmpRC = RC_ERROR);                                                             //RADDAT
            clear IFS1028;                                                                  //RADDAT
            IFS10281 = i_path;                                                              //RADDAT
            IFS10282 = f_errno();                                                           //RADDAT
            IFS10283 = f_strerror(f_errno());                                               //RADDAT
            msg = AppMsg_newEscape('IFS1028': IFS1028);                                     //RADDAT
            fileID.ino = RC_ERROR;                                                          //RADDAT
            fileID.dev = RC_ERROR;                                                          //RADDAT
 X01     else;                                                                              //RADDAT
            msg = AppMsg_new(cMsg_ID_OK);                                                   //RADDAT
            fileID = produceUniqueFileID(st_stat);                                          //RADDAT
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
         return fileID;                                                                     //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P ifsFile_getUniqueID...                                                                 RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Returns the unique file ID of the file referenced by a                               RADDAT
     *  given file handle.                                                                   RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_hFile       - The handle of a file opened by ifsFile_open().                      RADDAT
     *   o_msg         - Error message.                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   fileID        - Returns the file ID on success, else cIFS_ERROR.                    RADDAT
     *=========================================================================              RADDAT
    P ifsFile_getUniqueIDH...                                                                RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsFile_getUniqueIDH...                                                                RADDAT
     D                 PI                         likeds(ifs_uniqueFileID_t)                  RADDAT
     D i_hFile                             const  like(ifs_hFile_t         )                  RADDAT
     D o_msg                                      like(msg_t               )                  RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D fileID          DS                  likeds(ifs_uniqueFileID_t) inz                     RADDAT
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_msg           C                   const(2)                                           RADDAT
     *                                                                                       RADDAT
     *  Fields for optional parameters                                                       RADDAT
     D msg             DS                  likeds(msg_t    ) inz                              RADDAT
     *                                                                                       RADDAT
     *  Local fields                                                                         RADDAT
     D tmpRC           S             10I 0 inz                                                RADDAT
     *                                                                                       RADDAT
     *  stat() result data structure                                                         RADDAT
     D st_stat         DS                  likeds(st_stat_t) inz                              RADDAT
     *                                                                                       RADDAT
     *  File handle                                                                          RADDAT
     D handle          DS                  likeds(handle_t ) based(pHandle)                   RADDAT
     *                                                                                       RADDAT
CPY  /COPY QIFS2,IFS1028                         Failed to retrieve the unique file ID ...  RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         //Get access to file handle date                                                  //RADDAT
         pHandle = HANDLE_getPointer(i_hFile);                                              //RADDAT
                                                                                            //RADDAT
         //Get the file ID of the stream file                                              //RADDAT
         tmpRC = fstat(handle.hFileUnix: st_stat);                                          //RADDAT
                                                                                            //RADDAT
 B01     if (tmpRC = RC_ERROR);                                                             //RADDAT
            clear IFS1028;                                                                  //RADDAT
            IFS10281 = handle.path;                                                         //RADDAT
            IFS10282 = f_errno();                                                           //RADDAT
            IFS10283 = f_strerror(f_errno());                                               //RADDAT
            msg = AppMsg_newEscape('IFS1028': IFS1028);                                     //RADDAT
            fileID.ino = RC_ERROR;                                                          //RADDAT
            fileID.dev = RC_ERROR;                                                          //RADDAT
 X01     else;                                                                              //RADDAT
            msg = AppMsg_new(cMsg_ID_OK);                                                   //RADDAT
            fileID = produceUniqueFileID(st_stat);                                          //RADDAT
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
         return fileID;                                                                     //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P ifsFile_getUniqueIDH...                                                                RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Returns the file ID as shown at the WRKLNK 'Display Attributes' screen.              RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_path        - The name of a given stream file.                                    RADDAT
     *   o_msg         - Error message.                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   fileID        - Returns the file ID on success, else an empty string.               RADDAT
     *=========================================================================              RADDAT
    P ifsFile_getID...                                                                       RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsFile_getID...                                                                       RADDAT
     D                 PI                         like(ifs_fileID_t  )
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D fileID          S                   like(ifs_fileID_t) inz                             RADDAT
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_msg           C                   const(2)                                           RADDAT
     *                                                                                       RADDAT
     *  Fields for optional parameters                                                       RADDAT
     D msg             DS                  likeds(msg_t     ) inz
     *                                                                                       RADDAT
     *  Local fields                                                                         RADDAT
     D tmpRC           S             10I 0 inz                                                RADDAT
     *                                                                                       RADDAT
     *  stat() result data structure                                                         RADDAT
     D st_stat         DS                  likeds(st_stat_t) inz                              RADDAT
     *                                                                                       RADDAT
CPY  /COPY QIFS2,IFS1037                         Failed to retrieve the file ID ...         RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         //Get the file ID of the stream file                                              //RADDAT
         tmpRC = stat(ifsPath_fixSyntax(i_path): %addr(st_stat));                           //RADDAT
                                                                                            //RADDAT
 B01     if (tmpRC = RC_ERROR);                                                             //RADDAT
            clear IFS1037;                                                                  //RADDAT
            IFS10371 = i_path;                                                              //RADDAT
            IFS10372 = f_errno();                                                           //RADDAT
            IFS10373 = f_strerror(f_errno());                                               //RADDAT
            msg = AppMsg_newEscape('IFS1037': IFS1037);                                     //RADDAT
            fileID = '';                                                                    //RADDAT
 X01     else;                                                                              //RADDAT
            msg = AppMsg_new(cMsg_ID_OK);                                                   //RADDAT
            fileID = produceFileID(st_stat);                                                //RADDAT
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
         return fileID;                                                                     //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P ifsFile_getID...                                                                       RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Returns the file ID of the file referenced by a given file handle                    RADDAT
     *   as shown at the WRKLNK 'Display Attributes' screen.                                 RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_hFile       - The handle of a file opened by ifsFile_open().                      RADDAT
     *   o_msg         - Error message.                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   fileID        - Returns the file ID on success, else an empty string.               RADDAT
     *=========================================================================              RADDAT
    P ifsFile_getIDH...                                                                      RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsFile_getIDH...                                                                      RADDAT
     D                 PI                         like(ifs_fileID_t  )
     D i_hFile                             const  like(ifs_hFile_t   )                        RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D fileID          S                   like(ifs_fileID_t) inz
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_msg           C                   const(2)                                           RADDAT
     *                                                                                       RADDAT
     *  Fields for optional parameters                                                       RADDAT
     D msg             DS                  likeds(msg_t     ) inz
     *                                                                                       RADDAT
     *  Local fields                                                                         RADDAT
     D tmpRC           S             10I 0 inz                                                RADDAT
     *                                                                                       RADDAT
     *  stat() result data structure                                                         RADDAT
     D st_stat         DS                  likeds(st_stat_t) inz                              RADDAT
     *                                                                                       RADDAT
     *  File handle                                                                          RADDAT
     D handle          DS                  likeds(handle_t ) based(pHandle)                   RADDAT
     *                                                                                       RADDAT
CPY  /COPY QIFS2,IFS1037                         Failed to retrieve the file ID ...         RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         //Get access to file handle date                                                  //RADDAT
         pHandle = HANDLE_getPointer(i_hFile);                                              //RADDAT
                                                                                            //RADDAT
         //Get the file ID of the stream file                                              //RADDAT
         tmpRC = fstat(handle.hFileUnix: st_stat);                                          //RADDAT
                                                                                            //RADDAT
 B01     if (tmpRC = RC_ERROR);                                                             //RADDAT
            clear IFS1037;                                                                  //RADDAT
            IFS10371 = handle.path;                                                         //RADDAT
            IFS10372 = f_errno();                                                           //RADDAT
            IFS10373 = f_strerror(f_errno());                                               //RADDAT
            msg = AppMsg_newEscape('IFS1037': IFS1037);                                     //RADDAT
            fileID = '';                                                                    //RADDAT
 X01     else;                                                                              //RADDAT
            msg = AppMsg_new(cMsg_ID_OK);                                                   //RADDAT
            fileID = produceFileID(st_stat);                                                //RADDAT
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
         return fileID;                                                                     //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P ifsFile_getIDH...                                                                      RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Produces a unique temporary stream file name.                                        RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   o_msg         - Error message.                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   tmpPath       - Returns a temporary IFS path name on success, else                  RADDAT
     *                   an empty string.                                                    RADDAT
     *=========================================================================              RADDAT
    P ifsFile_getTempPath...                                                                 RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsFile_getTempPath...                                                                 RADDAT
     D                 PI                         like(ifs_path_t )                           RADDAT
     D o_msg                                      like(msg_t      )                           RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D tmpPath         S                   like(ifs_path_t ) inz                              RADDAT
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_msg           C                   const(1)                                           RADDAT
     *                                                                                       RADDAT
     *  Fields for optional parameters                                                       RADDAT
     D msg             DS                  likeds(msg_t    ) inz                              RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D pTmpPath        S               *   inz                                                RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     *                                                                                       RADDAT
CPY  /COPY QIFS2,IFS1023                         Failed to produce temporary path name.     RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         //Produce temporary path name ...                                                 //RADDAT
         f_clrErrno();                                                                      //RADDAT
                                                                                            //RADDAT
         pTmpPath = ifs_tmpnam(*NULL);                                                      //RADDAT
                                                                                            //RADDAT
 B01     if (pTmpPath <> *NULL);                                                            //RADDAT
            tmpPath = %str(pTmpPath);
            msg = AppMsg_new(cMsg_ID_OK);                                                   //RADDAT
 X01     else;                                                                              //RADDAT
            clear IFS1023;                                                                  //RADDAT
            IFS10231 = f_errno();                                                           //RADDAT
            IFS10232 = f_strerror(f_errno());                                               //RADDAT
            msg = AppMsg_newEscape('IFS1023': IFS1023);                                     //RADDAT
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
         return tmpPath;                                                                    //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P ifsFile_getTempPath...                                                                 RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Compares the content of two files with each other.                                   RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_path1       - The name of a given stream file.                                    RADDAT
     *   i_path2       - The name of a given stream file.                                    RADDAT
     *   i_options     - Optional. Compare options. (Not yet used.)                          RADDAT
     *   o_msg         - Error message.                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   rc            - Returns cIFS_OK on success, else cIFS_ERROR.                        RADDAT
     *=========================================================================              RADDAT
    P ifsFile_compare...                                                                     RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsFile_compare...                                                                     RADDAT
     D                 PI            10I 0                                                    RADDAT
     D i_path1                             const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D i_path2                             const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D i_options                     10I 0 const  options(*nopass: *omit)                     RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D rc              S             10I 0 inz(cIFS_ERROR)                                    RADDAT
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_options       C                   const(3)                                           RADDAT
     D p_msg           C                   const(4)                                           RADDAT
     *                                                                                       RADDAT
     *  Fields for optional parameters                                                       RADDAT
     D options         S                   like(i_options   ) inz                             RADDAT
     D msg             DS                  likeds(msg_t     ) inz                             RADDAT
     *                                                                                       RADDAT
     *  Local fields                                                                         RADDAT
     D path1           S                   like(i_path1     ) inz                             RADDAT
     D path2           S                   like(i_path2     ) inz                             RADDAT
     D size1           S             10I 0 inz                                                RADDAT
     D size2           S             10I 0 inz                                                RADDAT
     D fd1             S             10I 0 inz(-1)                                            RADDAT
     D fd2             S             10I 0 inz(-1)                                            RADDAT
     D pBuffer1        S               *   inz                                                RADDAT
     D pBuffer2        S               *   inz                                                RADDAT
     *                                                                                       RADDAT
     D BUFF_SIZE       S             10I 0 inz                                                RADDAT
     *                                                                                       RADDAT
     *  Messages                                                                             RADDAT
CPY  /COPY QIFS2,IFS1000                         Failed to open file '&1'.                  RADDAT
CPY  /COPY QIFS2,IFS1004                         Fehler beim Lesen aus Datei '&1' ...       RADDAT
CPY  /COPY QIFS2,IFS1053                         Datei stimmen nicht überein.               RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         //Get optional parameters                                                         //RADDAT
         //... options                                                                     //RADDAT
 B01     if (%parms() >= p_options and %addr(i_options) <> *NULL);                          //RADDAT
            options = i_options;                                                            //RADDAT
 X01     else;                                                                              //RADDAT
            options = 0;                                                                    //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
 B01     dou '1';                                                                           //RADDAT
                                                                                            //RADDAT
            //Ensure that file 1 exists.                                                   //RADDAT
 B02        if (not ifsFile_exist(i_path1: msg));                                           //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            //Ensure that file 2 exists.                                                   //RADDAT
 B02        if (not ifsFile_exist(i_path2: msg));                                           //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            //Compare the size of the files                                                //RADDAT
            size1 = ifsFile_getSize(i_path1: msg);                                          //RADDAT
 B02        if (msg.ID <> cMsg_ID_OK);                                                      //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            size2 = ifsFile_getSize(i_path2: msg);                                          //RADDAT
 B02        if (msg.ID <> cMsg_ID_OK);                                                      //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
 B02        if (size1 <> size2);                                                            //RADDAT
               clear IFS1053;                                                               //RADDAT
               IFS10531 = 1;         //File size                                           //RADDAT
               IFS10532 = i_path1;                                                          //RADDAT
               IFS10533 = i_path2;                                                          //RADDAT
               msg = AppMsg_newEscape('IFS1053': IFS1053);                                  //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            //Content of the files                                                         //RADDAT
            BUFF_SIZE = 1024 * 32;                                                          //RADDAT
                                                                                            //RADDAT
            path1 = ifsPath_fixSyntax(i_path1);                                             //RADDAT
            fd1 = open(path1: O_RDONLY + O_SHARE_RDONLY);                                   //RADDAT
 B02        if (fd1 = RC_ERROR);                                                            //RADDAT
               clear IFS1000;                                                               //RADDAT
               IFS10001 = path1;                                                            //RADDAT
               IFS10002 = f_errno();                                                        //RADDAT
               IFS10003 = f_strerror(f_errno());                                            //RADDAT
               msg = AppMsg_newEscape('IFS1000': IFS1000);                                  //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            path2 = ifsPath_fixSyntax(i_path2);                                             //RADDAT
            fd2 = open(path2: O_RDONLY + O_SHARE_RDONLY);                                   //RADDAT
 B02        if (fd2 = RC_ERROR);                                                            //RADDAT
               clear IFS1000;                                                               //RADDAT
               IFS10001 = path2;                                                            //RADDAT
               IFS10002 = f_errno();                                                        //RADDAT
               IFS10003 = f_strerror(f_errno());                                            //RADDAT
               msg = AppMsg_newEscape('IFS1000': IFS1000);                                  //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            pBuffer1 = %alloc(BUFF_SIZE);                                                   //RADDAT
            pBuffer2 = %alloc(BUFF_SIZE);                                                   //RADDAT
                                                                                            //RADDAT
 B02        dou (size1 <= 0 or size2 <= 0);                                                 //RADDAT
               size1 = read(fd1: pBuffer1: BUFF_SIZE);                                      //RADDAT
               size2 = read(fd2: pBuffer2: BUFF_SIZE);                                      //RADDAT
                                                                                            //RADDAT
 B03           if (size1 = RC_ERROR);                                                       //RADDAT
                  clear IFS1004;                                                            //RADDAT
                  IFS10041 = path1;                                                         //RADDAT
                  IFS10042 = f_errno();                                                     //RADDAT
                  IFS10043 = f_strerror(f_errno());                                         //RADDAT
                  msg = AppMsg_newEscape('IFS1004': IFS1004);                               //RADDAT
                  leave;                                                                    //RADDAT
 E03           endif;                                                                       //RADDAT
                                                                                            //RADDAT
 B03           if (size2 = RC_ERROR);                                                       //RADDAT
                  clear IFS1004;                                                            //RADDAT
                  IFS10041 = path2;                                                         //RADDAT
                  IFS10042 = f_errno();                                                     //RADDAT
                  IFS10043 = f_strerror(f_errno());                                         //RADDAT
                  msg = AppMsg_newEscape('IFS1004': IFS1004);                               //RADDAT
                  leave;                                                                    //RADDAT
 E03           endif;                                                                       //RADDAT
                                                                                            //RADDAT
 B03           if (size1 <> size2);                                                         //RADDAT
                  clear IFS1053;                                                            //RADDAT
                  IFS10531 = 1;         //File size                                        //RADDAT
                  IFS10532 = i_path1;                                                       //RADDAT
                  IFS10533 = i_path2;                                                       //RADDAT
                  msg = AppMsg_newEscape('IFS1053': IFS1053);                               //RADDAT
                  leave;                                                                    //RADDAT
 E03           endif;                                                                       //RADDAT
                                                                                            //RADDAT
 B03           if (size1 > 0 and
                   compareBuffers(pBuffer1: pBuffer2: size1) <> cIFS_OK);                   //RADDAT
                  clear IFS1053;                                                            //RADDAT
                  IFS10531 = 2;         //File content                                     //RADDAT
                  IFS10532 = i_path1;                                                       //RADDAT
                  IFS10533 = i_path2;                                                       //RADDAT
                  msg = AppMsg_newEscape('IFS1053': IFS1053);                               //RADDAT
                  leave;                                                                    //RADDAT
 E03           endif;                                                                       //RADDAT
                                                                                            //RADDAT
 E02        enddo;                                                                          //RADDAT
                                                                                            //RADDAT
            dealloc(N) pBuffer1;                                                            //RADDAT
            dealloc(N) pBuffer2;                                                            //RADDAT
                                                                                            //RADDAT
            callp close(fd1);                                                               //RADDAT
            fd1 = -1;                                                                       //RADDAT
            callp close(fd2);                                                               //RADDAT
            fd2 = -1;                                                                       //RADDAT
                                                                                            //RADDAT
 B02        if (msg.ID <> cMsg_ID_OK);                                                      //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            rc = cIFS_OK;                                                                   //RADDAT
 E01     enddo;                                                                             //RADDAT
                                                                                            //RADDAT
         //Ensure that files are closed and buffers are deallocated                        //RADDAT
 B01     if (fd1 <> -1);                                                                    //RADDAT
            callp close(fd1);                                                               //RADDAT
            fd1 = -1;                                                                       //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
 B01     if (fd2 <> -1);                                                                    //RADDAT
            callp close(fd2);                                                               //RADDAT
            fd1 = -2;                                                                       //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
 B01     if (pBuffer1 <> *NULL);                                                            //RADDAT
            dealloc(N) pBuffer1;                                                            //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
 B01     if (pBuffer2 <> *NULL);                                                            //RADDAT
            dealloc(N) pBuffer2;                                                            //RADDAT
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
         return rc;                                                                         //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P ifsFile_compare...                                                                     RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
   R *  *** private ***                                                                      RADDAT
     *  Checks the size of a given handle buffer and reallocates memory                      RADDAT
     *  if the buffer is too small.                                                          RADDAT
     *=========================================================================              RADDAT
    P checkHandleBufferSizeAndReallocate...                                                  RADDAT
    P                 B                                                                      RADDAT
     *                                                                                       RADDAT
     D checkHandleBufferSizeAndReallocate...                                                  RADDAT
     D                 PI              *                                                      RADDAT
     D io_buffer                                  likeds(buffer_t )                           RADDAT
     D i_newSize                     10I 0 const                                              RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
 B01     if (i_newSize > io_buffer.size);                                                   //RADDAT
 B02        if (io_buffer.pData = *NULL);                                                   //RADDAT
               io_buffer.size  = cBUFFER_SIZE;                                              //RADDAT
               io_buffer.pData = %alloc(io_buffer.size);                                    //RADDAT
 X02        else;                                                                           //RADDAT
               io_buffer.size  = io_buffer.size * 2;                                        //RADDAT
               io_buffer.pData = %realloc(io_buffer.pData: io_buffer.size);                 //RADDAT
 E02        endif;                                                                          //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         p_assert(io_buffer.size > i_newSize
                  : 'Handle buffer size too small');                                        //RADDAT
                                                                                            //RADDAT
         return io_buffer.pData;                                                            //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P checkHandleBufferSizeAndReallocate...                                                  RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
   R *  *** private ***                                                                      RADDAT
     *  Free a given temporary buffer.                                                       RADDAT
     *=========================================================================              RADDAT
    P freeHandleBuffer...
    P                 B                                                                      RADDAT
     *                                                                                       RADDAT
     D freeHandleBuffer...
     D                 PI                                                                     RADDAT
     D io_buffer                                  likeds(buffer_t )                           RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
 B01     if (io_buffer.pData <> *NULL);                                                     //RADDAT
            dealloc(N) io_buffer.pData;                                                     //RADDAT
            io_buffer.size = 0;                                                             //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         p_assert(io_buffer.pData = *NULL and io_buffer.size = 0
                  : 'Handle buffer not correctly cleared');                                 //RADDAT
                                                                                            //RADDAT
         return;                                                                            //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P freeHandleBuffer...
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
   R *  *** private ***                                                                      RADDAT
     *  Produces a unique file ID.                                                           RADDAT
     *=========================================================================              RADDAT
    P produceUniqueFileID...                                                                 RADDAT
    P                 B                                                                      RADDAT
     *                                                                                       RADDAT
     D produceUniqueFileID...                                                                 RADDAT
     D                 PI                         likeds(ifs_uniqueFileID_t)                  RADDAT
     D i_st_stat                           const  likeds(st_stat_t    )                       RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D fileID          DS                  likeds(ifs_uniqueFileID_t) inz                     RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         //---------------------------------------------------------------------- //      //RADDAT
         //From the iSeries Information Center V5R4, stat()--Get File Information //      //RADDAT
         //---------------------------------------------------------------------- //      //RADDAT
         //The file ID for the object. This number uniquely identifies            //      //RADDAT
         //the object within a file system. When st_ino and st_dev are            //      //RADDAT
         //used together, they uniquely identify the object on the system.        //      //RADDAT
         //---------------------------------------------------------------------- //      //RADDAT
                                                                                            //RADDAT
         fileID.ino = i_st_stat.ino;                                                        //RADDAT
         fileID.dev = i_st_stat.dev;                                                        //RADDAT
                                                                                            //RADDAT
         return fileID;                                                                     //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P produceUniqueFileID...                                                                 RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
   R *  *** private ***                                                                      RADDAT
     *  Produces a file ID as shown at the WRKLNK 'Display Attributes' screen.               RADDAT
     *=========================================================================              RADDAT
    P produceFileID...                                                                       RADDAT
    P                 B                                                                      RADDAT
     *                                                                                       RADDAT
     D produceFileID...                                                                       RADDAT
     D                 PI                         like(ifs_fileID_t   )
     D i_st_stat                           const  likeds(st_stat_t    )                       RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D fileID          S                   like(ifs_fileID_t) inz
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D tmpFileID       DS                  qualified                                          RADDAT
     D  rdev                         10U 0 inz                                  dev_t  =uint  RADDAT
     D  nlink32                      10U 0 inz                                  nlink32_t=ulngRADDAT
     D  ino_gen_id                   10U 0 inz                                  uint          RADDAT
     D  ino                          10U 0 inz                                  ino_t  =uint  RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         tmpFileID.rdev       = i_st_stat.rdev;                                             //RADDAT
         tmpFileID.nlink32    = i_st_stat.nlink32;                                          //RADDAT
         tmpFileID.ino_gen_id = i_st_stat.ino_gen_id;                                       //RADDAT
         tmpFileID.ino        = i_st_stat.ino;                                              //RADDAT
                                                                                            //RADDAT
         fileID = f_cvtBufferToHexString(%addr(tmpFileID): %size(tmpFileID));               //RADDAT
                                                                                            //RADDAT
         return fileID;                                                                     //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P produceFileID...                                                                       RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
   R *  *** private ***                                                                      RADDAT
     *  Append the data of a given file to a target file.                                    RADDAT
     *=========================================================================              RADDAT
    P copyFileCreateOrAppend...                                                              RADDAT
    P                 B                                                                      RADDAT
     *                                                                                       RADDAT
     D copyFileCreateOrAppend...                                                              RADDAT
     D                 PI              N                                                      RADDAT
     D  i_fromPath                         const  like(ifs_path_t    )                        RADDAT
     D  i_toPath                           const  like(ifs_path_t    )                        RADDAT
     D  i_toCcsid                          const  like(ifs_ccsid_t   )                        RADDAT
     D  o_msg                                     like(msg_t         )                        RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D isCopied        S               N   inz(cFalse)                                        RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D isCodeConversion...                                                                    RADDAT
     D                 S               N   inz(cFalse)                                        RADDAT
     D hFrom           S             10I 0 inz                                                RADDAT
     D hTo             S             10I 0 inz                                                RADDAT
     D byteRead        S             10I 0 inz                                                RADDAT
     D byteWrite       S             10I 0 inz                                                RADDAT
     D inBufSize       S             10U 0 inz                                                RADDAT
     D outBufSize      S             10U 0 inz                                                RADDAT
     D pInBuffer       S               *   inz                                                RADDAT
     D pOutBuffer      S               *   inz                                                RADDAT
     D inBuffer        S           8192A   inz                                                RADDAT
     D outBuffer       S          16384A   inz                                                RADDAT
     D toOptions       S             10I 0 inz                                                RADDAT
     D msg             DS                  likeds(msg_t ) inz                                 RADDAT
     *                                                                                       RADDAT
     *  iconv() helper field s                                                               RADDAT
     D hIconv          DS                  likeds(iconv_t  ) inz                              RADDAT
     D st_stat_from    DS                  likeds(st_stat_t) inz                              RADDAT
     D st_stat_to      DS                  likeds(st_stat_t) inz                              RADDAT
     *                                                                                       RADDAT
CPY  /COPY QIFS2,IFS1043                         Stopped copying file because only &2 ...   RADDAT
CPY  /COPY QIFS2,IFS1044                         Stopped copying file because of error ...  RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         msg = AppMsg_new(cMSG_ID_OK);                                                      //RADDAT
                                                                                            //RADDAT
 B01     dou '1';                                                                           //RADDAT
                                                                                            //RADDAT
            //Get CCSIDs of FROM and TO file                                               //RADDAT
 B02        if (stat(i_fromPath: %addr(st_stat_from)) = RC_ERROR);                          //RADDAT
               clear IFS1044;                                                               //RADDAT
               IFS10441 = f_errno();                                                        //RADDAT
               IFS10442 = f_strerror(f_errno());                                            //RADDAT
               msg = AppMsg_newEscape('IFS1044': IFS1044);                                  //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
 B02        if (stat(i_toPath: %addr(st_stat_to)) = RC_ERROR);                              //RADDAT
 B03           if (f_errno() <> ENOENT_C);                                                  //RADDAT
                  clear IFS1044;                                                            //RADDAT
                  IFS10441 = f_errno();                                                     //RADDAT
                  IFS10442 = f_strerror(f_errno());                                         //RADDAT
                  msg = AppMsg_newEscape('IFS1044': IFS1044);                               //RADDAT
                  leave;                                                                    //RADDAT
 E03           endif;                                                                       //RADDAT
               st_stat_to.ccsid = i_toCcsid;                                                //RADDAT
               toOptions = O_CREAT + O_EXCL;                                                //RADDAT
 X02        else;                                                                           //RADDAT
               toOptions = O_APPEND;                                                        //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            //Initialize code conversion                                                   //RADDAT
 B02        if (st_stat_from.ccsid <> st_stat_to.ccsid);                                    //RADDAT
               hIconv = Iconv_initialize(st_stat_from.ccsid: st_stat_to.ccsid);             //RADDAT
               isCodeConversion = cTrue;                                                    //RADDAT
 X02        else;                                                                           //RADDAT
               isCodeConversion = cFalse;                                                   //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            monitor;                                                                        //RADDAT
                                                                                            //RADDAT
               //Open files                                                                //RADDAT
               hFrom = open(i_fromPath: O_SHARE_RDONLY + O_RDONLY);                         //RADDAT
               hTo   = open(i_toPath  : O_SHARE_RDONLY + O_WRONLY + toOptions);             //RADDAT
                                                                                            //RADDAT
               //Read input data, convert it to target CCSID and append data               //RADDAT
               //to target file.                                                           //RADDAT
               byteRead = read(hFrom: %addr(inBuffer): %size(inBuffer));                    //RADDAT
 B02           dow (byteRead > 0);                                                          //RADDAT
                                                                                            //RADDAT
                  //Convert input data to target CCSID                                     //RADDAT
 B03              if (isCodeConversion);                                                    //RADDAT
                     inBufSize  = byteRead;                                                 //RADDAT
                     outBufSize = %size(outBuffer);                                         //RADDAT
                     pInBuffer  = %addr(inBuffer );                                         //RADDAT
                     pOutBuffer = %addr(outBuffer);                                         //RADDAT
 B04                 if (iconv(hIconv: pInBuffer : inBufSize
                                     : pOutBuffer: outBufSize) = cICONV_ERROR);             //RADDAT
                        clear IFS1044;                                                      //RADDAT
                        IFS10441 = f_errno();                                               //RADDAT
                        IFS10442 = f_strerror(f_errno());                                   //RADDAT
                        msg = AppMsg_newEscape('IFS1044': IFS1044);                         //RADDAT
                        leave;                                                              //RADDAT
 E04                 endif;                                                                 //RADDAT
                     outBufSize = %size(outBuffer) - outBufSize;                            //RADDAT
                     byteWrite = write(hTo: %addr(outBuffer): outBufSize);                  //RADDAT
                     byteRead  = outBufSize;                                                //RADDAT
 X03              else;                                                                     //RADDAT
                     byteWrite = write(hTo: %addr(inBuffer): byteRead);                     //RADDAT
 E03              endif;                                                                    //RADDAT
                                                                                            //RADDAT
 B03              select;                                                                   //RADDAT
                  when (byteWrite = RC_ERROR);                                              //RADDAT
                     clear IFS1044;                                                         //RADDAT
                     IFS10441 = f_errno();                                                  //RADDAT
                     IFS10442 = f_strerror(f_errno());                                      //RADDAT
                     msg = AppMsg_newEscape('IFS1044': IFS1044);                            //RADDAT
                     leave;                                                                 //RADDAT
                  when (byteWrite <> byteRead);                                             //RADDAT
                     clear IFS1043;                                                         //RADDAT
                     IFS10431 = byteRead;                                                   //RADDAT
                     IFS10432 = byteWrite;                                                  //RADDAT
                     msg = AppMsg_newEscape('IFS1043': IFS1043);                            //RADDAT
                     leave;                                                                 //RADDAT
 E03              endsl;                                                                    //RADDAT
                                                                                            //RADDAT
                  //Read next chunk of data                                                //RADDAT
                  byteRead = read(hFrom: %addr(inBuffer): %size(inBuffer));                 //RADDAT
 B03              select;                                                                   //RADDAT
                  when (byteRead = RC_ERROR);                                               //RADDAT
                     clear IFS1044;                                                         //RADDAT
                     IFS10441 = f_errno();                                                  //RADDAT
                     IFS10442 = f_strerror(f_errno());                                      //RADDAT
                     msg = AppMsg_newEscape('IFS1044': IFS1044);                            //RADDAT
                     leave;                                                                 //RADDAT
                  when (byteRead = 0);                                                      //RADDAT
                     isCopied = cTrue;                                                      //RADDAT
 E03              endsl;                                                                    //RADDAT
 E02           enddo;                                                                       //RADDAT
                                                                                            //RADDAT
               //Close files                                                               //RADDAT
               callp(E) close(hFrom);                                                       //RADDAT
               callp(E) close(hTo);                                                         //RADDAT
            on-error;                                                                       //RADDAT
               clear IFS1044;                                                               //RADDAT
               IFS10441 = f_errno();                                                        //RADDAT
               IFS10442 = f_strerror(f_errno());                                            //RADDAT
               msg = AppMsg_newEscape('IFS1044': IFS1044);                                  //RADDAT
               isCopied = cFalse;                                                           //RADDAT
            endmon;                                                                         //RADDAT
                                                                                            //RADDAT
            //Terminate code conversion                                                    //RADDAT
 B02        if (isCodeConversion);                                                          //RADDAT
               Iconv_terminate(hIconv);                                                     //RADDAT
               isCodeConversion = cFalse;                                                   //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
 E01     enddo;                                                                             //RADDAT
                                                                                            //RADDAT
         o_msg = msg;                                                                       //RADDAT
                                                                                            //RADDAT
         return isCopied;                                                                   //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P copyFileCreateOrAppend...                                                              RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
   R *  *** private ***                                                                      RADDAT
     *  Compares the given buffers with each other.                                          RADDAT
     *=========================================================================              RADDAT
    P compareBuffers...                                                                      RADDAT
    P                 B                                                                      RADDAT
     *                                                                                       RADDAT
     D compareBuffers...                                                                      RADDAT
     D                 PI            10I 0                                                    RADDAT
     D i_pBuffer1                      *   const                                              RADDAT
     D i_pBuffer2                      *   const                                              RADDAT
     D i_size                        10I 0 const                                              RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D rc              S             10I 0 inz(cIFS_ERROR)                                    RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
 B01     if (memcmp(i_pBuffer1: i_pBuffer2: i_size) <> 0);                                  //RADDAT
            rc = cIFS_ERROR;                                                                //RADDAT
 X01     else;                                                                              //RADDAT
            rc = cIFS_OK;                                                                   //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         return rc;                                                                         //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P compareBuffers...                                                                      RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
