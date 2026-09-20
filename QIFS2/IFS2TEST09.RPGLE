     *===============================================================*                       RADDAT
     *  Test: ifsPath_move(... cIFS_MOVE_FILE_REPLACE)               *                       RADDAT
     *---------------------------------------------------------------*                       RADDAT
     *    CALL PGM(IFS2TEST09)                                       *                       RADDAT
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
     *                              BNDSRVPGM(&LI/IFS2     +         *                       RADDAT
     *                                        &LI/BASICS1) +         *                       RADDAT
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
CPY  /COPY QIFS2,PIFS2                                                                      RADDAT
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
CPY  /COPY QBASICS1,PBASICS1                    
     *                                                                                       RADDAT
     D PGM_ENTRY_POINT...                                                                     RADDAT
     D                 PR                         extpgm('IFS2TEST06')                        RADDAT
     *                                                                                       RADDAT
     D main...                                                                                RADDAT
     D                 PR                                                                     RADDAT
     *                                                                                       RADDAT
     *  Creates a temporary file.                                                            RADDAT
     D createTempFile...                                                                      RADDAT
     D                 PR                         like(ifs_path_t )                           RADDAT
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
     * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                         RADDAT
      /FREE
                                                                                            //RADDAT
         main();                                                                            //RADDAT
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
     *  Creates a temporary file.                                                            RADDAT
     *===============================================================*                       RADDAT
    P createTempFile...                                                                      RADDAT
    P                 B                                                                      RADDAT
     *                                                                                       RADDAT
     D createTempFile...                                                                      RADDAT
     D                 PI                         like(ifs_path_t )                           RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D fileName        S                   like(ifs_path_t ) inz                              RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D hFile           S                   like(ifs_hFile_t) inz                              RADDAT
     * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                         RADDAT
      /FREE
                                                                                            //RADDAT
         //Create a temporary file                                                         //RADDAT
         fileName = ifsFile_getTempPath();                                                  //RADDAT
         fileName = ifsPath_getDirectory(fileName) +
                    'ifs2_' + ifsPath_getName(fileName);                                    //RADDAT
         hFile = ifsFile_open(fileName
                              : O_RDONLY + O_SHARE_RDONLY +
                                O_CREAT + O_EXCL + O_TEXTDATA
                              : *: *: *);                                                   //RADDAT
         ifsFile_close(hFile);                                                              //RADDAT
                                                                                            //RADDAT
         return fileName;                                                                   //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P createTempFile...                                                                      RADDAT
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
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D tmpRC           S             10I 0 inz                                                RADDAT
     D fileNameTemp    S                   like(ifs_path_t ) inz                              RADDAT
     D fileNameRoot    S                   like(ifs_path_t ) inz                              RADDAT
     D fileNameRnmd    S                   like(ifs_path_t ) inz                              RADDAT
     D crtTimeTemp     S               Z                     inz                              RADDAT
     D crtTimeRoot     S               Z                     inz                              RADDAT
     D msg             DS                  likeds(msg_t    ) inz                              RADDAT
     * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                         RADDAT
      /FREE
                                                                                            //RADDAT
         //Create a temporary file                                                         //RADDAT
         fileNameTemp = createTempFile();                                                   //RADDAT
         fileNameRoot = '/' + ifsPath_getName(filenameTemp);                                //RADDAT
         fileNameRnmd = fileNameTemp + '.renamed';                                          //RADDAT
                                                                                            //RADDAT
         //Copy it to the root directory                                                   //RADDAT
         p_wait(1);  //Ensure different timestamps                                         //RADDAT
                                                                                            //RADDAT
         tmpRC = ifsFile_copy(fileNameTemp: '/': cIFS_COPY_FILE_DFT: *: msg);               //RADDAT
         p_assert(tmpRC = cIFS_OK
                  : 'Expected cIFS_OK from ifsFile_copy()');                                //RADDAT
         p_assert(msg.ID = cMSG_ID_OK
                  : 'Expected cMSG_ID_OK from ifsFile_copy()');                             //RADDAT
                                                                                            //RADDAT
         //Get creation timestamps                                                         //RADDAT
         crtTimeTemp = ifsFile_getCreationTime(fileNameTemp);                               //RADDAT
         crtTimeRoot = ifsFile_getCreationTime('/' + fileNameTemp);                         //RADDAT
                                                                                            //RADDAT
         //Try to move it to the root directory --> ERROR                                  //RADDAT
         tmpRC = ifsFile_move(fileNameTemp: '/': cIFS_MOVE_FILE_DFT: msg);                  //RADDAT
         p_assert(tmpRC = cIFS_ERROR
                  : 'Expected cIFS_ERROR from ifsFile_move()');                             //RADDAT
         p_assert(msg.ID = 'IFS1003'
                  : 'Expected ''IFS1003'' from ifsFile_move()');                            //RADDAT
                                                                                            //RADDAT
         //Now move it to the root, replacing the existing file                            //RADDAT
         tmpRC = ifsFile_move(fileNameTemp: '/': cIFS_MOVE_FILE_REPLACE: msg);              //RADDAT
         p_assert(tmpRC = cIFS_OK
                  : 'Expected cIFS_OK from ifsFile_move()');                                //RADDAT
         p_assert(msg.ID = cMSG_ID_OK
                  : 'Expected cMSG_ID_OK from ifsFile_move()');                             //RADDAT
                                                                                            //RADDAT
         //Check that file has been moved.                                                 //RADDAT
         p_assert(not ifsFile_exist(fileNameTemp)
                  : 'Expected temp. file moved to root');                                   //RADDAT
         p_assert(crtTimeTemp = ifsFile_getCreationTime(fileNameRoot)
                  : 'Expected the root file to have the creation timestamp +
                     of the temp. file, because it was moved');                             //RADDAT
                                                                                            //RADDAT
         //Move it back to where it came from, rename it --> ERROR                         //RADDAT
         tmpRC = ifsFile_move(fileNameRoot: fileNameRnmd: *: msg);                          //RADDAT
         p_assert(tmpRC = cIFS_ERROR
                  : 'Expected cIFS_ERROR from ifsFile_move()');                             //RADDAT
         p_assert(msg.ID = 'IFS1047'
                  : 'Expected ''IFS1047'' from ifsFile_move()');                            //RADDAT
                                                                                            //RADDAT
         //Move it back to where it came from, rename it                                   //RADDAT
         tmpRC = ifsFile_move(fileNameRoot: fileNameRnmd
                              : cIFS_MOVE_FILE_ALLOW_RENAME: msg);                          //RADDAT
         p_assert(tmpRC = cIFS_OK
                  : 'Expected cIFS_OK from ifsFile_move()');                                //RADDAT
         p_assert(msg.ID = cMSG_ID_OK
                  : 'Expected cMSG_ID_OK from ifsFile_move()');                             //RADDAT
                                                                                            //RADDAT
         //Remove temorary file                                                            //RADDAT
         ifsFile_delete(fileNameRnmd);                                                      //RADDAT
                                                                                            //RADDAT
         //Remove file from root directory                                                 //RADDAT
         //ifsFile_delete(fileNameRoot);                                                   //RADDAT
                                                                                            //RADDAT
                                                                                            //RADDAT
                                                                                            //RADDAT
                                                                                            //RADDAT
         return;                                                                            //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P main...                                                                                RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
