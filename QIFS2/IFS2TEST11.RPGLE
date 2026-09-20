     *===============================================================*                       RADDAT
     *  Test: ifsFile_compare()                                      *                       RADDAT
     *---------------------------------------------------------------*                       RADDAT
     *    CALL PGM(IFS2TEST11)                                       *                       RADDAT
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
     *                              TGTRLS(*CURRENT) +               *                       RADDAT
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
CPY  /COPY QIFS2,CLIB                                                                       RADDAT
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
     *                                                                                       RADDAT
     D PGM_ENTRY_POINT...                                                                     RADDAT
     D                 PR                         extpgm('IFS2TEST11')                        RADDAT
     *                                                                                       RADDAT
     D main...                                                                                RADDAT
     D                 PR                                                                     RADDAT
     *                                                                                       RADDAT
     *  Sends a message to QCMD                                                              RADDAT
     D sndMsg...                                                                              RADDAT
     D                 PR                                                                     RADDAT
     D  i_text                      128A   value  varying                                     RADDAT
     *                                                                                       RADDAT
     *  Program status data structure                                                        RADDAT
     D sds            SDS                  qualified                                          RADDAT
     D  pgmLib                81     90A                                                      RADDAT
     D  pgmContProc          334    343A                                                      RADDAT
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
     *  Main procedure                                                                       RADDAT
     *===============================================================*                       RADDAT
    P main...                                                                                RADDAT
    P                 B                                                                      RADDAT
     *                                                                                       RADDAT
     D main...                                                                                RADDAT
     D                 PI                                                                     RADDAT
     *                                                                                       RADDAT
     D HELLO_WORLD     C                   'Hello World!'                                     RADDAT
     D BROWN_FOX       C                   'The quick brown fox jumps over the +              RADDAT
     D                                      lazy dog.'                                        RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D i               S             10I 0 inz                                                RADDAT
     D rc              S             10I 0 inz                                                RADDAT
     D path1           S                   like(ifs_path_t ) inz                              RADDAT
     D path2           S                   like(ifs_path_t ) inz                              RADDAT
     D fd1             S             10I 0 inz(-1)                                            RADDAT
     D fd2             S             10I 0 inz(-1)                                            RADDAT
     D buffer1         S          65535A   varying inz                                        RADDAT
     D buffer2         S          65535A   varying inz                                        RADDAT
     D msg             DS                  likeds(msg_t ) inz                                 RADDAT
     *                                                                                       RADDAT
CPY  /COPY QIFS2,IFS1053                         Datei stimmen nicht überein.               RADDAT
     * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                         RADDAT
      /FREE

                                                                                            //RADDAT
 B01     dou '1';                                                                           //RADDAT
                                                                                            //RADDAT
            //-----------------------------------------------------                        //RADDAT
            //  Compare files of different sizes                                           //RADDAT
            //-----------------------------------------------------                        //RADDAT
            path1 = ifsFile_getTempPath() + '.IFS2TEST11';                                  //RADDAT
            fd1 = open(path1: O_CREAT + O_TRUNC + O_WRONLY + O_SHARE_RDONLY
                            : S_IRWXU + S_IRWXG + S_IRWXO);                                 //RADDAT
 B02        if (fd1 = -1);                                                                  //RADDAT
               sndMsg(f_strError(f_errno()));                                               //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            path2 = ifsFile_getTempPath() + '.IFS2TEST11';                                  //RADDAT
            fd2 = open(path2: O_CREAT + O_TRUNC + O_WRONLY + O_SHARE_RDONLY
                            : S_IRWXU + S_IRWXG + S_IRWXO);                                 //RADDAT
 B02        if (fd2 = -1);                                                                  //RADDAT
               sndMsg(f_strError(f_errno()));                                               //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            buffer1 = HELLO_WORLD;                                                          //RADDAT
            buffer2 = BROWN_FOX;                                                            //RADDAT
            callp write(fd1: %addr(buffer1)+2: %len(buffer1));                              //RADDAT
            callp write(fd2: %addr(buffer2)+2: %len(buffer2));                              //RADDAT
                                                                                            //RADDAT
            callp close(fd1);                                                               //RADDAT
            fd1 = -1;                                                                       //RADDAT
            callp close(fd2);                                                               //RADDAT
            fd2 = -1;                                                                       //RADDAT
                                                                                            //RADDAT
            rc = ifsFile_compare(path1: path2: *: msg);                                     //RADDAT
 B02        if (rc <> cIFS_ERROR);                                                          //RADDAT
               sndMsg('Incorrect ''rc'' when comparing +
                       files of different sizes');                                          //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
 B02        if (msg.ID <> 'IFS1053');                                                       //RADDAT
               sndMsg('Incorrect ''msg.ID'' when comparing +
                       files of different sizes');                                          //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            IFS1053 = msg.data;                                                             //RADDAT
 B02        if (IFS10531 <> 1);                                                             //RADDAT
               sndMsg('Incorrect ''error code'' when comparing +
                       files of different sizes');                                          //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            unlink(path1);                                                                  //RADDAT
            unlink(path2);                                                                  //RADDAT
                                                                                            //RADDAT
            //-----------------------------------------------------                        //RADDAT
            //  Compare files of different content                                         //RADDAT
            //-----------------------------------------------------                        //RADDAT
            path1 = ifsFile_getTempPath() + '.IFS2TEST11';                                  //RADDAT
            fd1 = open(path1: O_CREAT + O_TRUNC + O_WRONLY + O_SHARE_RDONLY
                            : S_IRWXU + S_IRWXG + S_IRWXO);                                 //RADDAT
 B02        if (fd1 = -1);                                                                  //RADDAT
               sndMsg(f_strError(f_errno()));                                               //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            path2 = ifsFile_getTempPath() + '.IFS2TEST11';                                  //RADDAT
            fd2 = open(path2: O_CREAT + O_TRUNC + O_WRONLY + O_SHARE_RDONLY
                            : S_IRWXU + S_IRWXG + S_IRWXO);                                 //RADDAT
 B02        if (fd2 = -1);                                                                  //RADDAT
               sndMsg(f_strError(f_errno()));                                               //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            buffer1 = BROWN_FOX;                                                            //RADDAT
            %subst(buffer1: 10: %len(HELLO_WORLD)) = HELLO_WORLD;                           //RADDAT
            buffer2 = BROWN_FOX;                                                            //RADDAT
            callp write(fd1: %addr(buffer1)+2: %len(buffer1));                              //RADDAT
            callp write(fd2: %addr(buffer2)+2: %len(buffer2));                              //RADDAT
                                                                                            //RADDAT
            callp close(fd1);                                                               //RADDAT
            fd1 = -1;                                                                       //RADDAT
            callp close(fd2);                                                               //RADDAT
            fd2 = -1;                                                                       //RADDAT
                                                                                            //RADDAT
            rc = ifsFile_compare(path1: path2: *: msg);                                     //RADDAT
 B02        if (rc <> cIFS_ERROR);                                                          //RADDAT
               sndMsg('Incorrect ''rc'' when comparing +
                       files of different sizes');                                          //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
 B02        if (msg.ID <> 'IFS1053');                                                       //RADDAT
               sndMsg('Incorrect ''msg.ID'' when comparing +
                       files of different sizes');                                          //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            IFS1053 = msg.data;                                                             //RADDAT
 B02        if (IFS10531 <> 2);                                                             //RADDAT
               sndMsg('Incorrect ''error code'' when comparing +
                       files of different sizes');                                          //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            unlink(path1);                                                                  //RADDAT
            unlink(path2);                                                                  //RADDAT
                                                                                            //RADDAT
                                                                                            //RADDAT
            //-----------------------------------------------------                        //RADDAT
            //  Compare files with same content                                            //RADDAT
            //-----------------------------------------------------                        //RADDAT
            path1 = ifsFile_getTempPath() + '.IFS2TEST11';                                  //RADDAT
            fd1 = open(path1: O_CREAT + O_TRUNC + O_WRONLY + O_SHARE_RDONLY
                            : S_IRWXU + S_IRWXG + S_IRWXO);                                 //RADDAT
 B02        if (fd1 = -1);                                                                  //RADDAT
               sndMsg(f_strError(f_errno()));                                               //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            path2 = ifsFile_getTempPath() + '.IFS2TEST11';                                  //RADDAT
            fd2 = open(path2: O_CREAT + O_TRUNC + O_WRONLY + O_SHARE_RDONLY
                            : S_IRWXU + S_IRWXG + S_IRWXO);                                 //RADDAT
 B02        if (fd2 = -1);                                                                  //RADDAT
               sndMsg(f_strError(f_errno()));                                               //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            buffer1 = BROWN_FOX;                                                            //RADDAT
            buffer2 = BROWN_FOX;                                                            //RADDAT
                                                                                            //RADDAT
 B02        for i = 1 to 10000;                                                             //RADDAT
               callp write(fd1: %addr(buffer1)+2: %len(buffer1));                           //RADDAT
               callp write(fd2: %addr(buffer2)+2: %len(buffer2));                           //RADDAT
 E02        endfor;                                                                         //RADDAT
                                                                                            //RADDAT
            callp close(fd1);                                                               //RADDAT
            fd1 = -1;                                                                       //RADDAT
            callp close(fd2);                                                               //RADDAT
            fd2 = -1;                                                                       //RADDAT
                                                                                            //RADDAT
            rc = ifsFile_compare(path1: path2: *: msg);                                     //RADDAT
 B02        if (rc <> cIFS_ERROR);                                                          //RADDAT
               sndMsg('Incorrect ''rc'' when comparing +
                       files of different sizes');                                          //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
 B02        if (msg.ID <> 'IFS1053');                                                       //RADDAT
               sndMsg('Incorrect ''msg.ID'' when comparing +
                       files of different sizes');                                          //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            IFS1053 = msg.data;                                                             //RADDAT
 B02        if (IFS10531 <> 2);                                                             //RADDAT
               sndMsg('Incorrect ''error code'' when comparing +
                       files of different sizes');                                          //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            unlink(path1);                                                                  //RADDAT
            unlink(path2);                                                                  //RADDAT
                                                                                            //RADDAT
 E01     enddo;                                                                             //RADDAT
                                                                                            //RADDAT
 B01     if (fd1 > 0);                                                                      //RADDAT
            callp close(fd1);                                                               //RADDAT
            fd1 = -1;                                                                       //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
 B01     if (fd2 > 0);                                                                      //RADDAT
            callp close(fd2);                                                               //RADDAT
            fd2 = -1;                                                                       //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         unlink(path1);                                                                     //RADDAT
         unlink(path2);                                                                     //RADDAT
                                                                                            //RADDAT
         return;                                                                            //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P main...                                                                                RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
