      *===============================================================*                       RADDAT
      *     Demo: Writing Hex Values to an IFS file                   *                       RADDAT
      *===============================================================*                       RADDAT
      *     CALL PGM(ZEBRALBL3) PARM('HexValues.txt')                 *                       RADDAT
      *===============================================================*                       RADDAT
      * >>PRE-COMPILER<<                                              *                       RADDAT
      *   >>CRTCMD<< CRTRPGMOD    MODULE(&LI/&OB) +                   *                       RADDAT
      *                           SRCFILE(&SL/&SF) +                  *                       RADDAT
      *                           SRCMBR(&SM);                        *                       RADDAT
      *   >>COMPILE<<                                                 *                       RADDAT
      *     >>PARM<< TRUNCNBR(*NO);                                   *                       RADDAT
      *     >>PARM<< DBGVIEW(*LIST);                                  *                       RADDAT
      *   >>END-COMPILE<<                                             *                       RADDAT
      *   >>EXECUTE<<                                                 *                       RADDAT
      *   >>CMD<<    CRTPGM       PGM(&LI/&OB) +                      *                       RADDAT
      *                           MODULE(&LI/&OB) +                   *                       RADDAT
      *                           BNDSRVPGM(*LIBL/BASICS1 +           *                       RADDAT
      *                                     *LIBL/IFS2) +             *                       RADDAT
      *                           DETAIL(*BASIC) +                    *                       RADDAT
      *                           ACTGRP(*NEW);                       *                       RADDAT
      *                                                               *                       RADDAT
      * >>END-PRE-COMPILER<<                                          *                       RADDAT
      *===============================================================*                       RADDAT
     H DEBUG                                                                                  RADDAT
     H OPTION(*SRCSTMT : *NODEBUGIO)                                                          RADDAT
     H DECEDIT('0,') DATEDIT(*DMY.)                                                           RADDAT
     H DATFMT(*ISO )  TIMFMT(*ISO )                                                           RADDAT
     H EXPROPTS(*RESDECPOS)                                                                   RADDAT
     H EXTBININT(*YES)                                                                        RADDAT
      *===============================================================*                       RADDAT
      *                                                                                       RADDAT
      * ------------------------------------                                                  RADDAT
      *  Type definitions                                                                     RADDAT
      * ------------------------------------                                                  RADDAT
      *                                                                                       RADDAT
      * ------------------------------------                                                  RADDAT
      *  External Prototypes                                                                  RADDAT
      * ------------------------------------                                                  RADDAT
 CPY  /COPY QBASICS1,PBASICS1                      Tools/400 Runtime Libary                   RADDAT
 CPY  /COPY QIFS2,PIFS2                            IFS Procedures                             RADDAT
      *                                                                                       RADDAT
      * ------------------------------------                                                  RADDAT
      *  Global Fields                                                                        RADDAT
      * ------------------------------------                                                  RADDAT
      *                                                                                       RADDAT
      * ------------------------------------                                                  RADDAT
      *  Globale Constants                                                                    RADDAT
      * ------------------------------------                                                  RADDAT
      *                                                                                       RADDAT
      * ------------------------------------                                                  RADDAT
      *  Prototypes                                                                           RADDAT
      * ------------------------------------                                                  RADDAT
     D PGM_ENTRY_POINT...                                                                     RADDAT
     D                 PR                  extpgm('ZEBRALBL3')                                RADDAT
     D gi_path                       32A   const                                              RADDAT
      *                                                                                       RADDAT
     D main...                                                                                RADDAT
     D                 PR                         extproc('main')                             RADDAT
     D i_path                        32A   value  varying                                     RADDAT
      *                                                                                       RADDAT
      *  Sends a message to QCMD                                                              RADDAT
     D sndMsg...                                                                              RADDAT
     D                 PR                         extproc('sndMsg')                           RADDAT
     D  i_text                      128A   value  varying                                     RADDAT
      *                                                                                       RADDAT
      *  ... Execute Command (QCMDEXC) API                                                    RADDAT
     D QCMDEXC...                                                                             RADDAT
     D                 PR                  extpgm('QCMDEXC')                                  RADDAT
     D  i_cmd                     32702A   const  options(*varsize)                           RADDAT
     D  i_length                     15P 5 const                                              RADDAT
      *                                                                                       RADDAT
      * ------------------------------------                                                  RADDAT
      *  Program status information structure                                                 RADDAT
      * ------------------------------------                                                  RADDAT
     D sds            SDS                  qualified                                          RADDAT
     D  pgmName                1     10A                                        Pgm Name      RADDAT
      *                                                                                       RADDAT
      *===============================================================*                       RADDAT
      *  Program Entry Point                                                                  RADDAT
      *===============================================================*                       RADDAT
     D PGM_ENTRY_POINT...                                                                     RADDAT
     D                 PI                                                                     RADDAT
     D gi_path                       32A   const                                              RADDAT
      *                                                                                       RADDAT
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                         RADDAT
      /FREE
                                                                                            //RADDAT
         *inlr = *on;                                                                       //RADDAT
                                                                                            //RADDAT
         if (%parms() < 1);                                                                 //RADDAT
            sndMsg('Usage: CALL PGM(ZEBRALBL3) PARM(''HexValues'')');                       //RADDAT
            return;                                                                         //RADDAT
         endif;                                                                             //RADDAT
                                                                                            //RADDAT
         main(%trimR(gi_path));                                                             //RADDAT
                                                                                            //RADDAT
         return;                                                                            //RADDAT
                                                                                            //RADDAT
      /END-FREE
      *                                                                                       RADDAT
      *===============================================================*                       RADDAT
      *  *** private ***                                                                      RADDAT
      *  Sends a message to the command line                                                  RADDAT
      *===============================================================*                       RADDAT
     P sndMsg...                                                                              RADDAT
     P                 B                                                                      RADDAT
      *                                                                                       RADDAT
     D sndMsg...                                                                              RADDAT
     D                 PI                                                                     RADDAT
     D  i_text                      128A   value  varying                                     RADDAT
      *                                                                                       RADDAT
      *  Return value                                                                         RADDAT
     D pBuffer         S               *   inz                                                RADDAT
      *                                                                                       RADDAT
      *  Local fields                                                                         RADDAT
     D msgKey          S              4A                        inz                           RADDAT
      *                                                                                       RADDAT
     D qMsgF           DS                  qualified            inz                           RADDAT
     D  name                         10A                                                      RADDAT
     D  lib                          10A                                                      RADDAT
      *                                                                                       RADDAT
     D errCode         DS                  qualified            inz                           RADDAT
     D  bytPrv                       10I 0                                                    RADDAT
     D  bytAvl                       10I 0                                                    RADDAT
     D  excID                         7A                                                      RADDAT
     D  reserved                      1A                                                      RADDAT
     D  excDta                      256A                                                      RADDAT
      *                                                                                       RADDAT
      *  Send Program Message (QMHSNDPM) API                                                  RADDAT
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
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                         RADDAT
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
      *                                                                                       RADDAT
     P sndMsg...                                                                              RADDAT
     P                 E                                                                      RADDAT
      *                                                                                       RADDAT
      *===============================================================*                       RADDAT
      *  Main procedure                                                                       RADDAT
      *===============================================================*                       RADDAT
     P main...                                                                                RADDAT
     P                 B                                                                      RADDAT
      *                                                                                       RADDAT
     D main...                                                                                RADDAT
     D                 PI                                                                     RADDAT
     D i_path                        32A   value  varying                                     RADDAT
      *                                                                                       RADDAT
      *  Handle for the output file                                                           RADDAT
     D hFile           S                   like(ifs_hFile_t) inz                              RADDAT
      *  Generic message data structure                                                       RADDAT
     D msg             DS                  likeds(msg_t    ) inz                              RADDAT
      *                                                                                       RADDAT
      *  Carriage return + linefeed                                                           RADDAT
     D CRLF            C                   x'0D0A'                                            RADDAT
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                         RADDAT
      /FREE
                                                                                            //RADDAT
         msg = f_newMsg(cMsg_ID_OK);                                                        //RADDAT
                                                                                            //RADDAT
         // Initialize house keeping fields                                                 //RADDAT
         hFile = HANDLE_null();                                                             //RADDAT
                                                                                            //RADDAT
         // Do until everything is done or an error occured                                 //RADDAT
         dou '1';                                                                           //RADDAT
                                                                                            //RADDAT
            // Open IFS file for binary mode                                                //RADDAT
            // (Binary mode, because we do not want any                                     //RADDAT
            //  character translation taking place)                                         //RADDAT
            hFile = ifsFile_open(i_path
                                 : O_SHARE_RDONLY + O_WRONLY +
                                   O_CREAT + O_EXCL
                                 : *: *: msg);                                              //RADDAT
            if (msg.ID <> cMsg_ID_OK);                                                      //RADDAT
               leave;                                                                       //RADDAT
            endif;                                                                          //RADDAT
                                                                                            //RADDAT
            // Append preamble bytes to the IFS file.                                       //RADDAT
            // Use hex values because there is no character translation                     //RADDAT
            // because of output binary mode. We do not need the length                     //RADDAT
            // parameter if the hex string does not contain x'00'.                          //RADDAT
                                                                                            //RADDAT
            // Zebra command: change caret                                                  //RADDAT
            ifsFile_write(hFile: x'7E43435E': 0);                                           //RADDAT
                                                                                            //RADDAT
            // New line                                                                     //RADDAT
            ifsFile_write(hFile: CRLF: 0);                                                  //RADDAT
                                                                                            //RADDAT
            // Zebra command: map clear                                                     //RADDAT
            ifsFile_write(hFile: x'5E4D4359': 0);                                           //RADDAT
                                                                                            //RADDAT
            // New line                                                                     //RADDAT
            ifsFile_write(hFile: CRLF: 0);                                                  //RADDAT
                                                                                            //RADDAT
            // Close label file                                                             //RADDAT
            ifsFile_close(hFile);                                                           //RADDAT
                                                                                            //RADDAT
            // In case you program design requires to close the file, maybe because         //RADDAT
            // the preamble bytes are written by a special procedure or program,            //RADDAT
            // you can reopen it with the APPEND parameter                                  //RADDAT
                                                                                            //RADDAT
            // Reopen file to append label data                                             //RADDAT
            hFile = ifsFile_open(i_path
                                 : O_SHARE_RDONLY + O_WRONLY + O_APPEND
                                 : *: *: msg);                                              //RADDAT
            if (msg.ID <> cMsg_ID_OK);                                                      //RADDAT
               leave;                                                                       //RADDAT
            endif;                                                                          //RADDAT
                                                                                            //RADDAT
            // Write some label data                                                        //RADDAT
            ifsFile_write(hFile: x'5E536F6D6520': 0);    // 'Some '                         //RADDAT
            ifsFile_write(hFile: x'6C6162656C20': 0);    // 'label '                        //RADDAT
            ifsFile_write(hFile: x'64617461': 0);        // 'data'                          //RADDAT
                                                                                            //RADDAT
            // New line                                                                     //RADDAT
            ifsFile_write(hFile: CRLF: 0);                                                  //RADDAT
                                                                                            //RADDAT
            // Close label file                                                             //RADDAT
            ifsFile_close(hFile);                                                           //RADDAT
         enddo;                                                                             //RADDAT
                                                                                            //RADDAT
         // House keeping                                                                   //RADDAT
         if (not Handle_isNull(hFile));                                                     //RADDAT
            ifsFile_close(hFile);                                                           //RADDAT
         endif;                                                                             //RADDAT
                                                                                            //RADDAT
         // Send error message if necessary                                                 //RADDAT
         if (msg.ID <> cMsg_ID_OK);                                                         //RADDAT
            sndMsg(f_rtvMsgText(msg: *));                                                   //RADDAT
         endif;                                                                             //RADDAT
                                                                                            //RADDAT
         return;                                                                            //RADDAT
                                                                                            //RADDAT
      /END-FREE
      *                                                                                       RADDAT
     P main...                                                                                RADDAT
     P                 E                                                                      RADDAT
      *                                                                                       RADDAT
