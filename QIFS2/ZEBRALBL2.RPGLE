**FREE
//===============================================================*
//     Demo: Print Zebra Label reading from buffer               *
//===============================================================*
//     CALL PGM(ZEBRALBL2) PARM('Decoded_Label.txt')             *
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
DCL-F QSYSPRT PRINTER(1) USAGE(*output) USROPN OFLIND(*in70);
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
DCL-PR PGM_ENTRY_POINT EXTPGM('ZEBRALBL1');
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
  sndMsg('Usage: CALL PGM(ZEBRALBL2) PARM(''Decoded_Label.txt'')');
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
  //  Handle for the input file
  DCL-S hFile LIKE(ifs_hFile_t) INZ;
  //  Offset to next output byte
  DCL-S offset INT(10) INZ;
  //  Number of bytes read from the input file
  DCL-S length INT(10) INZ;
  //  RPG requires a data structure when used for a 'write' statement
  DCL-DS char1 LEN(1) BASED(pChar1);
  END-DS;
  //  Input buffer with some sample data
  DCL-S pBuffer POINTER INZ;
  //  Total number of bytes sent to the printer
  DCL-S totalBytes INT(10) INZ;
  //  Generic message data structure
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  DCL-C OVERRIDE_QSYSPRT_TO_USERASCII 'OVRPRTF FILE(QSYSPRT) TOFILE(*FILE) DEVTYPE(*USERASCII) +
    OVRSCOPE(*CALLLVL)';
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  msg = f_newMsg(cMsg_ID_OK);

  // Initialize house keeping fields
  hFile = HANDLE_null();
  pBuffer = *NULL;

  // Do until everything is done or an error occured
  dou '1';

    // Override printer file QSYSPRT to *USERASCII
    // The override effects the current call stack frame only,
    // because of OVRSCOPE(*CALLLVL). It is automatically
    // removed when the call stack frame ends.
    qcmdexc(OVERRIDE_QSYSPRT_TO_USERASCII
            : %len(OVERRIDE_QSYSPRT_TO_USERASCII));

    // Open IFS file with label data for binary mode
    // (Binary mode, because we do not want any
    //  character translation taking place)
    hFile = ifsFile_open(i_path
                         : O_SHARE_RDONLY + O_RDONLY
                         : *omit: *omit: msg);
    if (msg.ID <> cMsg_ID_OK);
      leave;
    endif;

    // Get size of input file
    length = ifsFile_getSize(i_path);

    // Allocate buffer
    pBuffer = %alloc(length);

    // Get some sample data from the IFS file
    // (The may also be passed to the program as a parameter)
    length = ifsFile_read(hFile: pBuffer: length: msg);
    if (msg.ID <> cMsg_ID_OK);
      leave;
    endif;

    // Close label file
    ifsFile_close(hFile);

    // Open printer file
    open QSYSPRT;

    // Read label data byte by byte and send it to the printer
    offset = 0;
    dow (offset < length);

      // get byte from buffer
      pChar1 = pBuffer + offset;

      // print data as single line
      write QSYSPRT char1;
      totalBytes += 1;

      offset += 1;
    enddo;

    // Free buffer
    dealloc(N) pBuffer;

    // Close printer file
    close QSYSPRT;
  enddo;

  // House keeping (takes place in case of errors)
  if (not Handle_isNull(hFile));
    ifsFile_close(hFile);
  endif;

  if (%open(QSYSPRT));
    close QSYSPRT;
  endif;

  if (pBuffer <> *NULL);
    dealloc(N) pBuffer;
  endif;

  // Send error message if necessary
  if (msg.ID <> cMsg_ID_OK);
    sndMsg(f_rtvMsgText(msg: *omit));
  endif;

  sndMsg(%trimR(sds.pgmName) + ' sent ' + %char(totalBytes) +
         ' bytes to the printer.');

  return;

//
END-PROC MAIN;
//
