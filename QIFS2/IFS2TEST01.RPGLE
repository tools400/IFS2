     *===============================================================*                       RADDAT
     *  Test: Create/Write/Read/Delete/Attr stream file              *                       RADDAT
     *---------------------------------------------------------------*                       RADDAT
     *    CALL PGM(IFS2TEST01) // using a temp. stream file          *                       RADDAT
     *    CALL PGM(IFS2TEST01) PARM('/home/raddatz/tmpFileName')     *                       RADDAT
     *===============================================================*                       RADDAT
     *   >>PRE-COMPILER<<                                            *                       RADDAT
     *                                                               *                       RADDAT
     *     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                *                       RADDAT
     *                              SRCFILE(&SL/&SF) +               *                       RADDAT
     *                              SRCMBR(&SM);                     *                       RADDAT
     *                                                               *                       RADDAT
     *     >>COMPILE<<                                               *                       RADDAT
     *       >>PARM<< TRUNCNBR(*NO);                                 *                       RADDAT
     *       >>PARM<< DBGVIEW(*LIST);                                *                       RADDAT
     *       >>PARM<< TGTRLS(*CURRENT);                              *                       RADDAT
     *     >>END-COMPILE<<                                           *                       RADDAT
     *                                                               *                       RADDAT
     *     >>EXECUTE<<                                               *                       RADDAT
     *                                                               *                       RADDAT
     *     >>CMD<<     CRTPGM       PGM(&LI/&OB) +                   *                       RADDAT
     *                              MODULE(&LI/&OB) +                *                       RADDAT
     *                              ACTGRP(*NEW) +                   *                       RADDAT
     *                              BNDSRVPGM(&LI/IFS2       +       *                       RADDAT
     *                                        *LIBL/BASICS1) +       *                       RADDAT
     *                              BNDDIR(QC2LE         ) +         *                       RADDAT
     *                              TGTRLS(*CURRENT) +               *
     *                              DETAIL(*BASIC);                  *                       RADDAT
     *                                                               *                       RADDAT
     *   >>END-PRE-COMPILER<<                                        *                       RADDAT
     *===============================================================*                       RADDAT
     H DEBUG                                                                                  RADDAT
     H OPTION(*SRCSTMT : *NODEBUGIO)                                                          RADDAT
     H DECEDIT('0,') DATEDIT(*DMY.)                                                           RADDAT
     H DATFMT(*ISO )  TIMFMT(*ISO )                                                           RADDAT
     H EXPROPTS(*RESDECPOS)                                                                   RADDAT
     H EXTBININT(*YES)                                                                        RADDAT
     *===============================================================*                       RADDAT
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  Type Definitions                                                                     RADDAT
     * ------------------------------------                                                  RADDAT
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  External Prototypes                                                                  RADDAT
     * ------------------------------------                                                  RADDAT
CPY  /COPY QIFS2,CEELIB                          CEE APIs                                   RADDAT
CPY  /COPY QIFS2,PIFS2                                                                      RADDAT
CPY  /COPY QBASICS1,PBASICS1                                                                RADDAT
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  Global Fields                                                                        RADDAT
     * ------------------------------------                                                  RADDAT
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  Global Constants                                                                     RADDAT
     * ------------------------------------                                                  RADDAT
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  Prototypes                                                                           RADDAT
     * ------------------------------------                                                  RADDAT
     *                                                                                       RADDAT
     D PGM_ENTRY_POINT...                                                                     RADDAT
     D                 PR                         extpgm('IFS2TEST01')                        RADDAT
     D  gi_path                      32A   const  options(*nopass)                            RADDAT
     *                                                                                       RADDAT
     D main...                                                                                RADDAT
     D                 PR                                                                     RADDAT
     D  i_path                             value  like(ifs_path_t )                           RADDAT
     D                                            options(*trim)                              RADDAT
     *                                                                                       RADDAT
     *  Sends a message to QCMD                                                              RADDAT
     D sndMsg...                                                                              RADDAT
     D                 PR                                                                     RADDAT
     D  i_text                      128A   value  varying                                     RADDAT
     *                                                                                       RADDAT
     *===============================================================*                       RADDAT
     *  Program Entry Point                                                                  RADDAT
     *===============================================================*                       RADDAT
     *                                                                                       RADDAT
     D PGM_ENTRY_POINT...                                                                     RADDAT
     D                 PI                                                                     RADDAT
     D  gi_path                      32A   const  options(*nopass)                            RADDAT
     *                                                                                       RADDAT
     D g_path          S                   like(ifs_path_t ) inz                              RADDAT
     * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                         RADDAT
      /FREE
                                                                                            //RADDAT
 B01     if (%parms() >= 1);                                                                //RADDAT
            main(gi_path);                                                                  //RADDAT
 X01     else;                                                                              //RADDAT
            g_path = ifsFile_getTempPath();                                                 //RADDAT
            g_path = ifsPath_getDirectory(g_path) +
                     'ifs2_' + ifsPath_getName(g_path);                                     //RADDAT
            main(g_path);                                                                   //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         *inlr = *on;                                                                       //RADDAT
                                                                                            //RADDAT
         return;                                                                            //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
     *===============================================================*                       RADDAT
     *  *** private ***                                                                      RADDAT
     *  Sends a message to the caller.                                                       RADDAT
     *===============================================================*                       RADDAT
    P sndMsg...                                                                              RADDAT
    P                 B                                                                      RADDAT
     *                                                                                       RADDAT
     D sndMsg...                                                                              RADDAT
     D                 PI                                                                     RADDAT
     D  i_text                      128A   value  varying                                     RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D pBuffer         S               *   inz                                                RADDAT
     *                                                                                       RADDAT
     *  Local fields                                                                         RADDAT
     D msgKey          S              4A                        inz                           RADDAT
     *                                                                                       RADDAT
     D qMsgF           DS                  qualified            inz                           RADDAT
     D  name                         10A                                                      RADDAT
     D  lib                          10A                                                      RADDAT
     *                                                                                       RADDAT
     D errCode         DS                  qualified            inz                           RADDAT
     D  bytPrv                       10I 0                                                    RADDAT
     D  bytAvl                       10I 0                                                    RADDAT
     D  excID                         7A                                                      RADDAT
     D  reserved                      1A                                                      RADDAT
     D  excDta                      256A                                                      RADDAT
     *                                                                                       RADDAT
     *  Send Program Message (QMHSNDPM) API                                                  RADDAT
     D QMHSNDPM        PR                         extpgm('QMHSNDPM')                          RADDAT
     D   i_msgID                      7A   const                                              RADDAT
     D   i_qMsgF                     20A   const                                              RADDAT
     D   i_msgData                32767A   const  options(*varsize )                          RADDAT
     D   i_length                    10I 0 const                                              RADDAT
     D   i_msgType                   10A   const                                              RADDAT
     D   i_callStkE               32767A   const  options(*varsize )                          RADDAT
     D   i_callStkC                  10I 0 const                                              RADDAT
     D   o_msgKey                     4A                                                      RADDAT
     D   io_ErrCode               32767A          options(*varsize )                          RADDAT
     D   i_lenStkE                   10I 0 const  options(*nopass  )                          RADDAT
     D   i_callStkEQ                 20A   const  options(*nopass  )                          RADDAT
     D   i_wait                      10I 0 const  options(*nopass  )                          RADDAT
     D   i_callStkEDT                10A   const  options(*nopass  )                          RADDAT
     D   i_ccsid                     10I 0 const  options(*nopass  )                          RADDAT
     * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                         RADDAT
      /FREE
                                                                                            //RADDAT
         clear qMsgF;                                                                       //RADDAT
         qMsgF.name = 'QCPFMSG';                                                            //RADDAT
         qMsgF.lib  = '*LIBL';                                                              //RADDAT
                                                                                            //RADDAT
         clear errCode;                                                                     //RADDAT
         errCode.bytPrv = %size(errCode);                                                   //RADDAT
                                                                                            //RADDAT
         QMHSNDPM('CPF9897': qMsgF: i_text: %len(i_text): '*INFO'
                  : '*CTLBDY': 1
                  : msgKey: errCode);                                                       //RADDAT
                                                                                            //RADDAT
         return;                                                                            //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P sndMsg...                                                                              RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *===============================================================*                       RADDAT
     *  Main procedure                                                                       RADDAT
     *===============================================================*                       RADDAT
    P main...                                                                                RADDAT
    P                 B                                                                      RADDAT
     *                                                                                       RADDAT
     D main...                                                                                RADDAT
     D                 PI                                                                     RADDAT
     D  i_path                             value  like(ifs_path_t )                           RADDAT
     D                                            options(*trim)                              RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D rc              S             10I 0                          inz                       RADDAT
     D path            S                   like(ifs_path_t )        inz                       RADDAT
     D hFile           S                   like(ifs_hFile_t)        inz                       RADDAT
     D bytesRead       S             10I 0                          inz                       RADDAT
     D buffer          S             64A                            inz                       RADDAT
     D size1           S             10I 0                          inz                       RADDAT
     D size2           S             10I 0                          inz                       RADDAT
     D crtTime         S               Z                            inz                       RADDAT
     D chgTime1        S               Z                            inz                       RADDAT
     D chgTime2        S               Z                            inz                       RADDAT
     D fileID1         S                   like(ifs_uniqueFileID_t) inz
     D fileID2         S                   like(ifs_uniqueFileID_t) inz
     D msg             DS                  likeds(msg_t           ) inz
     * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                         RADDAT
      /FREE
                                                                                            //RADDAT
         path = ifsPath_fixSyntax(%trimR(i_path));                                          //RADDAT
                                                                                            //RADDAT
 B01     dou '1';                                                                           //RADDAT
                                                                                            //RADDAT
 B02        if (ifsFile_exist(path));                                                       //RADDAT
               sndMsg('ERROR: File ' + path + ' already exists');                           //RADDAT
               return;                                                                      //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            //Open IFS file (using a bad name)                                             //RADDAT
            hFile = ifsFile_open('   /tmp/badName.file'
                                 : O_RDWR + O_SHARE_RDONLY +
                                   O_CREAT + O_EXCL + O_TEXTDATA
                                 : *
                                 : *
                                 : msg);                                                    //RADDAT
                                                                                            //RADDAT
            p_assert(msg.ID = 'IFS1000'
                     : 'Expected msg ID IFS1000 when using a bad name');                    //RADDAT
                                                                                            //RADDAT
            //Open IFS file (The file must not yet exists!)                                //RADDAT
            //Open flags:     read & write                                                 //RADDAT
            //                share with readers                                           //RADDAT
            //                create file, send message if file exists                     //RADDAT
            //                open for text data                                           //RADDAT
            hFile = ifsFile_open(path
                                 : O_RDWR + O_SHARE_RDONLY +
                                   O_CREAT + O_EXCL + O_TEXTDATA
                                 : *
                                 : *
                                 : msg);                                                    //RADDAT
                                                                                            //RADDAT
            //Get file creation time                                                       //RADDAT
            crtTime = ifsFile_getCreationTime(path);                                        //RADDAT
            p_assert(crtTime <> *LOVAL
                     : 'Expected the file to have a creation time');                        //RADDAT
                                                                                            //RADDAT
            //Get file last changed time                                                   //RADDAT
            chgTime1 = ifsFile_getDataChangeTime(path);                                     //RADDAT
            p_assert(chgTime1 <> *LOVAL
                     : 'Expected to get a time the file data was last changed');            //RADDAT
            p_assert(chgTime1 = crtTime
                     : 'Expected chgTime1 to be equal to crtTime');                         //RADDAT
                                                                                            //RADDAT
            //Wait a couple of seconds                                                     //RADDAT
            p_wait(3);                                                                      //RADDAT
                                                                                            //RADDAT
            //Write to file                                                                //RADDAT
            rc = ifsFile_write(hFile: 'Hello World!': 0);                                   //RADDAT
            p_assert(rc = 12
                     : 'Expected to write 12 byte to file');                                //RADDAT
                                                                                            //RADDAT
            //Set read pointer to 'World!'                                                 //RADDAT
            rc = ifsFile_seek(hFile: 6: SEEK_SET);                                          //RADDAT
                               //   ^-----------------  Offset to 'World', starting at 0.  //RADDAT
            p_assert(rc = cIFS_OK
                     : 'Expected cIFS_OK from ifsFile_seek()');                             //RADDAT
                                                                                            //RADDAT
            //Read from file                                                               //RADDAT
            rc = ifsFile_read(hFile: %addr(buffer): %size(buffer));                         //RADDAT
            p_assert(rc = 6
                     : 'Expected to read 6 byte from file');                                //RADDAT
            p_assert(buffer = 'World!'
                     : 'Expected to read ''World!'' from file');                            //RADDAT
                                                                                            //RADDAT
            //Get file size using the file descriptor                                      //RADDAT
            size1 = ifsFile_getSizeH(hFile);                                                //RADDAT
            p_assert(size1 = 12
                     : 'Expected a size of 12 byte');                                       //RADDAT
                                                                                            //RADDAT
            //Get unique file ID using the file descriptor                                 //RADDAT
            fileID1 = *ALLx'00';                                                            //RADDAT
            fileID1 = ifsFile_getUniqueIDH(hFile);                                          //RADDAT
            p_assert(fileID1 <> *ALLx'00'
                     : 'Expected fileID1 to be different from x''00''');                    //RADDAT
                                                                                            //RADDAT
            //Close IFS file                                                               //RADDAT
            ifsFile_close(hFile);                                                           //RADDAT
                                                                                            //RADDAT
            //Get file size                                                                //RADDAT
            size2 = ifsFile_getSize(path);                                                  //RADDAT
            p_assert(size2 = 12
                     : 'Expected a size of 12 byte');                                       //RADDAT
            p_assert(size1 = size2
                     : 'Expected size1 to be equal to size2');                              //RADDAT
                                                                                            //RADDAT
            //Get unique file ID                                                           //RADDAT
            fileID2 = *ALLx'00';                                                            //RADDAT
            fileID2 = ifsFile_getUniqueID(path);                                            //RADDAT
            p_assert(fileID2 <> *ALLx'00'
                     : 'Expected fileID2 to be different from x''00''');                    //RADDAT
            p_assert(fileID1 = fileID2
                     : 'Expected fileID1 to be equal to fileID2');                          //RADDAT
                                                                                            //RADDAT
            //Get file last changed time                                                   //RADDAT
            chgTime2 = ifsFile_getDataChangeTime(path);                                     //RADDAT
            p_assert(chgTime2 <> *LOVAL
                     : 'Expected to get a time the file data was last changed');            //RADDAT
            p_assert(chgTime1 <> chgTime2
                     : 'Expected chgTime1 to be different from chgTime2');                  //RADDAT
                                                                                            //RADDAT
            //----------------------------------                                           //RADDAT
            //  ifs_File_delete()                                                          //RADDAT
            //----------------------------------                                           //RADDAT
                                                                                            //RADDAT
            //Delete file using a bad name                                                 //RADDAT
            rc = ifsFile_delete(path + '.' + ifsFile_getTempPath(): msg);                   //RADDAT
            p_assert(rc = cIFS_ERROR
                     : 'Expected cIFS_ERROR from ifsFile_delete()');                        //RADDAT
            p_assert(msg.ID = 'IFS1005'
                     : 'Expected msg ID IFS1005 when using a bad name');                    //RADDAT
                                                                                            //RADDAT
            //----------------------------------                                           //RADDAT
            //  ifs_File_move()                                                            //RADDAT
            //----------------------------------                                           //RADDAT
                                                                                            //RADDAT
            //Move file to root '/' using a bad file name                                  //RADDAT
            rc = ifsFile_move('  /badDirectory/badFileName': '/': *: msg);                  //RADDAT
            p_assert(rc = cIFS_ERROR
                     : 'Expected cIFS_ERROR from ifsFile_move()');                          //RADDAT
            p_assert(msg.ID = 'IFS1012'
                     : 'Expected msg ID IFS1012 when using a bad name');                    //RADDAT
                                                                                            //RADDAT
            //Move file to root '/' using a bad directory name                             //RADDAT
            rc = ifsFile_move(path: '  /badDirName/': *: msg);                              //RADDAT
            p_assert(rc = cIFS_ERROR
                     : 'Expected cIFS_ERROR from ifsFile_move()');                          //RADDAT
            p_assert(msg.ID = 'IFS1011'
                     : 'Expected msg ID IFS1011 when using a bad name');                    //RADDAT
                                                                                            //RADDAT
            //Move file to root '/'                                                        //RADDAT
            rc = ifsFile_move(path: '/': *: msg);                                           //RADDAT
            p_assert(rc = cIFS_OK
                     : 'Expected cIFS_OK from ifsFile_move()');                             //RADDAT
                                                                                            //RADDAT
            //Move file back to its original location                                      //RADDAT
            rc = ifsFile_move('/' + ifsPath_getName(path)
                              : ifsPath_getDirectory(path): *: msg);                        //RADDAT
            p_assert(rc = cIFS_OK
                     : 'Expected cIFS_OK from ifsFile_move()');                             //RADDAT
                                                                                            //RADDAT
            //----------------------------------                                           //RADDAT
            //  ifs_File_rename()                                                          //RADDAT
            //----------------------------------                                           //RADDAT
                                                                                            //RADDAT
            //Rename file using a bad file name                                            //RADDAT
            rc = ifsFile_rename(path + '.badFileName'
                                : ifsPath_getName(path) + '.txt': msg);                     //RADDAT
            p_assert(rc = cIFS_ERROR
                     : 'Expected cIFS_ERROR from ifsFile_rename()');                        //RADDAT
            p_assert(msg.ID = 'IFS1012'
                     : 'Expected msg ID IFS1012 when using a bad name');                    //RADDAT
                                                                                            //RADDAT
            //Rename file, target contains directory                                       //RADDAT
            rc = ifsFile_rename(path
                                : '/badDirectory' +
                                  ifsPath_getName(path) + '.txt': msg);                     //RADDAT
            p_assert(rc = cIFS_ERROR
                     : 'Expected cIFS_ERROR from ifsFile_rename()');                        //RADDAT
            p_assert(msg.ID = 'IFS1014'
                     :'Expected msg ID IFS1014 when target contains directory');            //RADDAT
                                                                                            //RADDAT
            //Rename file, target exists                                                   //RADDAT
            rc = ifsFile_rename(path: ifsPath_getName(path): msg);                          //RADDAT
            p_assert(rc = cIFS_ERROR
                     : 'Expected cIFS_ERROR from ifsFile_rename()');                        //RADDAT
            p_assert(msg.ID = 'IFS1013'
                     :'Expected msg ID IFS1013 when target contains directory');            //RADDAT
                                                                                            //RADDAT
            //Rename file, to path + 'txt'                                                 //RADDAT
            rc = ifsFile_rename(path: ifsPath_getName(path) + '.txt': msg);                 //RADDAT
            p_assert(rc = cIFS_OK
                     : 'Expected cIFS_OK from ifsFile_rename()');                           //RADDAT
                                                                                            //RADDAT
            //Rename it back to its original name                                          //RADDAT
            rc = ifsFile_rename(path + '.txt': ifsPath_getName(path): msg);                 //RADDAT
            p_assert(rc = cIFS_OK
                     : 'Expected cIFS_OK from ifsFile_rename()');                           //RADDAT
                                                                                            //RADDAT
 E01     enddo;                                                                             //RADDAT
                                                                                            //RADDAT
 B01     if (ifsFile_exist(path));                                                          //RADDAT
            rc = ifsFile_delete(path);                                                      //RADDAT
            p_assert(rc = cIFS_OK
                     : 'Expected cIFS_ERROR from ifsFile_delete()');                        //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         return;                                                                            //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P main...                                                                                RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
