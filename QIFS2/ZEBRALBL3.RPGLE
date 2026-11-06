**FREE
//===============================================================*
//     Demo: Writing Hex Values to an IFS file                   *
//===============================================================*
//     CALL PGM(ZEBRALBL3) PARM('HexValues.txt')                 *
//===============================================================*
// >>PRE-COMPILER<<                                              *
//   >>CRTCMD<< CRTRPGMOD    MODULE(&LI/&OB) +                   *
//                           SRCFILE(&SL/&SF) +                  *
//                           SRCMBR(&SM);                        *
//   >>COMPILE<<                                                 *
//     >>PARM<< TRUNCNBR(*NO);                                   *
//     >>PARM<< DBGVIEW(*LIST);                                  *
//     >>PARM<< OPTION(*EVENTF);                                 *
//   >>END-COMPILE<<                                             *
//   >>EXECUTE<<                                                 *
//   >>CMD<<    CRTPGM       PGM(&LI/&OB) +                      *
//                           MODULE(&LI/&OB) +                   *
//                           BNDSRVPGM(*LIBL/BASICS1 +           *
//                                     *LIBL/IFS2) +             *
//                           DETAIL(*BASIC) +                    *
//                           ACTGRP(*NEW);                       *
//                                                               *
// >>END-PRE-COMPILER<<                                          *
//===============================================================*
CTL-OPT DEBUG OPTION(*SRCSTMT: *NODEBUGIO);
CTL-OPT DECEDIT('0,') DATEDIT(*DMY.);
CTL-OPT DATFMT(*ISO) TIMFMT(*ISO);
CTL-OPT EXPROPTS(*RESDECPOS);
CTL-OPT EXTBININT(*YES);
//===============================================================*
//
// ------------------------------------
//  Type definitions
// ------------------------------------
//
// ------------------------------------
//  External Prototypes
// ------------------------------------
/COPY QBASICS1,PBASICS1 Tools/400 Runtime Libary
/COPY QIFS2,PIFS2 IFS Procedures
//
// ------------------------------------
//  Global Fields
// ------------------------------------
//
// ------------------------------------
//  Globale Constants
// ------------------------------------
//
// ------------------------------------
//  Prototypes
// ------------------------------------
DCL-PR PGM_ENTRY_POINT EXTPGM('ZEBRALBL3');
  gi_path CHAR(32) CONST;
END-PR;
//
DCL-PR main EXTPROC('main');
  i_path VARCHAR(32) VALUE;
END-PR;
//
//  Sends a message to QCMD
DCL-PR sndMsg EXTPROC('sndMsg');
  i_text VARCHAR(128) VALUE;
END-PR;
//
//  ... Execute Command (QCMDEXC) API
DCL-PR QCMDEXC EXTPGM('QCMDEXC');
  i_cmd    CHAR(32702) CONST OPTIONS(*VARSIZE);
  i_length PACKED(15: 5) CONST;
END-PR;
//
// ------------------------------------
//  Program status information structure
// ------------------------------------
DCL-DS sds QUALIFIED PSDS;
  pgmName CHAR(10); // Pgm Name
END-DS;
//
//===============================================================*
//  Program Entry Point
//===============================================================*
DCL-PI PGM_ENTRY_POINT;
  gi_path CHAR(32) CONST;
END-PI;
//
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

*inlr = *on;

if (%parms() < 1);
  sndMsg('Usage: CALL PGM(ZEBRALBL3) PARM(''HexValues'')');
  return;
endif;

main(%trimR(gi_path));

return;

//
//===============================================================*
//  *** private ***
//  Sends a message to the command line
//===============================================================*
DCL-PROC sndMsg;
  //
  DCL-PI *N;
    i_text VARCHAR(128) VALUE;
  END-PI;
  //
  //  Return value
  DCL-S pBuffer POINTER INZ;
  //
  //  Local fields
  DCL-S msgKey CHAR(4) INZ;
  //
  DCL-DS qMsgF QUALIFIED INZ;
    name CHAR(10);
    lib  CHAR(10);
  END-DS;
  //
  DCL-DS errCode QUALIFIED INZ;
    bytPrv   INT(10);
    bytAvl   INT(10);
    excID    CHAR(7);
    reserved CHAR(1);
    excDta   CHAR(256);
  END-DS;
  //
  //  Send Program Message (QMHSNDPM) API
  DCL-PR QMHSNDPM EXTPGM('QMHSNDPM');
    i_msgID      CHAR(7) CONST;
    i_qMsgF      CHAR(20) CONST;
    i_msgData    CHAR(32767) CONST OPTIONS(*VARSIZE);
    i_length     INT(10) CONST;
    i_msgType    CHAR(10) CONST;
    i_callStkE   CHAR(32767) CONST OPTIONS(*VARSIZE);
    i_callStkC   INT(10) CONST;
    o_msgKey     CHAR(4);
    io_ErrCode   CHAR(32767) OPTIONS(*VARSIZE);
    i_lenStkE    INT(10) CONST OPTIONS(*NOPASS);
    i_callStkEQ  CHAR(20) CONST OPTIONS(*NOPASS);
    i_wait       INT(10) CONST OPTIONS(*NOPASS);
    i_callStkEDT CHAR(10) CONST OPTIONS(*NOPASS);
    i_ccsid      INT(10) CONST OPTIONS(*NOPASS);
  END-PR;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  clear qMsgF;
  qMsgF.name = 'QCPFMSG';
  qMsgF.lib  = '*LIBL';

  clear errCode;
  errCode.bytPrv = %size(errCode);

  QMHSNDPM('CPF9897': qMsgF: i_text: %len(i_text): '*INFO'
           : '*CTLBDY': 1
           : msgKey: errCode);

  return;

//
END-PROC;
//
//===============================================================*
//  Main procedure
//===============================================================*
DCL-PROC main;
  //
  DCL-PI *N;
    i_path VARCHAR(32) VALUE;
  END-PI;
  //
  //  Handle for the output file
  DCL-S hFile LIKE(ifs_hFile_t) INZ;
  //  Generic message data structure
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  Carriage return + linefeed
  DCL-C CRLF x'0D0A';
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  msg = f_newMsg(cMsg_ID_OK);

  // Initialize house keeping fields
  hFile = HANDLE_null();

  // Do until everything is done or an error occured
  dou '1';

    // Open IFS file for binary mode
    // (Binary mode, because we do not want any
    //  character translation taking place)
    hFile = ifsFile_open(i_path
                         : O_SHARE_RDONLY + O_WRONLY +
                           O_CREAT + O_EXCL
                         : *omit: *omit: msg);
    if (msg.ID <> cMsg_ID_OK);
      leave;
    endif;

    // Append preamble bytes to the IFS file.
    // Use hex values because there is no character translation
    // because of output binary mode. We do not need the length
    // parameter if the hex string does not contain x'00'.

    // Zebra command: change caret
    ifsFile_write(hFile: x'7E43435E': 0);

    // New line
    ifsFile_write(hFile: CRLF: 0);

    // Zebra command: map clear
    ifsFile_write(hFile: x'5E4D4359': 0);

    // New line
    ifsFile_write(hFile: CRLF: 0);

    // Close label file
    ifsFile_close(hFile);

    // In case you program design requires to close the file, maybe because
    // the preamble bytes are written by a special procedure or program,
    // you can reopen it with the APPEND parameter

    // Reopen file to append label data
    hFile = ifsFile_open(i_path
                         : O_SHARE_RDONLY + O_WRONLY + O_APPEND
                         : *omit: *omit: msg);
    if (msg.ID <> cMsg_ID_OK);
      leave;
    endif;

    // Write some label data
    ifsFile_write(hFile: x'5E536F6D6520': 0);    // 'Some '
    ifsFile_write(hFile: x'6C6162656C20': 0);    // 'label '
    ifsFile_write(hFile: x'64617461': 0);        // 'data'

    // New line
    ifsFile_write(hFile: CRLF: 0);

    // Close label file
    ifsFile_close(hFile);
  enddo;

  // House keeping
  if (not Handle_isNull(hFile));
    ifsFile_close(hFile);
  endif;

  // Send error message if necessary
  if (msg.ID <> cMsg_ID_OK);
    sndMsg(f_rtvMsgText(msg: *omit));
  endif;

  return;

//
END-PROC MAIN;
//
