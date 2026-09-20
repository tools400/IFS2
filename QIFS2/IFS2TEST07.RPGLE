     *===============================================================*                       RADDAT
     *  Test: ifsPath_getName()                                      *                       RADDAT
     *---------------------------------------------------------------*                       RADDAT
     *    CALL PGM(IFS2TEST07)                                       *                       RADDAT
     *    CALL PGM(IFS2TEST07) PARM('\home\raddatz\fileName.ext')    *                       RADDAT
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
     * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                         RADDAT
      /FREE
                                                                                            //RADDAT
 B01     if (%parms() >= 1);                                                                //RADDAT
            main(gi_path);                                                                  //RADDAT
 X01     else;                                                                              //RADDAT
            main('nameOnly.txt');                                                           //RADDAT
            main('/directoryWithFile/aFile.txt');                                           //RADDAT
            main('/directoryOnly/');                                                        //RADDAT
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
     D x               S             10I 0 inz                                                RADDAT
     D isDirectory     S               N   inz(cFalse)                                        RADDAT
     D isNameOnly      S               N   inz(cFalse)                                        RADDAT
     D directory       S                   like(ifs_path_t ) inz                              RADDAT
     D name            S                   like(ifs_path_t ) inz                              RADDAT
     D msg             DS                  likeds(msg_t    ) inz                              RADDAT
     * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                         RADDAT
      /FREE
                                                                                            //RADDAT
 B01     if (f_endsWith('/': i_path) or f_endsWith('\': i_path));                           //RADDAT
            isDirectory = cTrue;                                                            //RADDAT
 X01     else;                                                                              //RADDAT
            isDirectory = cFalse;                                                           //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         x = %scan('/': i_path) + %scan('\': i_path);                                       //RADDAT
 B01     if (x = 0);                                                                        //RADDAT
            isNameOnly = cTrue;                                                             //RADDAT
 X01     else;                                                                              //RADDAT
            isNameOnly = cFalse;                                                            //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         name = ifsPath_getName(i_path);                                                    //RADDAT
 B01     if (isDirectory);                                                                  //RADDAT
            p_assert(name = ''
                     : 'Expected ''name'' to be empty for DIRECTORIES');                    //RADDAT
 X01     else;                                                                              //RADDAT
            p_assert(name <> ''
                     : 'Expected ''name'' not to be empty for FILES');                      //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         directory = ifsPath_getDirectory(i_path);                                          //RADDAT
 B01     if (isNameOnly);                                                                   //RADDAT
            p_assert(directory = ''
                     : 'Expected ''directory'' to be empty +
                       if ''i_path'' is NAME_ONLY');                                        //RADDAT
 X01     else;                                                                              //RADDAT
            p_assert(directory <> ''
                     : 'Expected ''directory'' not to be empty +
                       if ''i_path'' is not NAME_ONLY');                                    //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
                                                                                            //RADDAT
         name = ifsPath_getName('/home/raddatz/directoryOnly/': cTrue);                     //RADDAT
         p_assert(name = 'directoryOnly/'
                  : 'Unexpected value for ''i_derectory = cTrue''');                        //RADDAT
                                                                                            //RADDAT
         return;                                                                            //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P main...                                                                                RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
