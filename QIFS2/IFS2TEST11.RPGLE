**FREE
//===============================================================*
//  Test: ifsFile_compare()                                      *
//---------------------------------------------------------------*
//    CALL PGM(IFS2TEST11)                                       *
//===============================================================*
//   >>PRE-COMPILER<<                                            *
//                                                               *
//     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                *
//                              SRCFILE(&SL/&SF) +               *
//                              SRCMBR(&SM);                     *
//                                                               *
//     >>COMPILE<<                                               *
//       >>PARM<< TRUNCNBR(*NO);                                 *
//       >>PARM<< DBGVIEW(*LIST);                                *
//       >>PARM<< TGTRLS(*CURRENT);                              *
//       >>PARM<< OPTION(*EVENTF);                               *
//     >>END-COMPILE<<                                           *
//                                                               *
//     >>EXECUTE<<                                               *
//                                                               *
//     >>CMD<<     CRTPGM       PGM(&LI/&OB) +                   *
//                              MODULE(&LI/&OB) +                *
//                              ACTGRP(*NEW) +                   *
//                              BNDSRVPGM(&LI/IFS2     +         *
//                                        &LI/BASICS1) +         *
//                              BNDDIR(QC2LE         ) +         *
//                              TGTRLS(*CURRENT) +               *
//                              DETAIL(*BASIC);                  *
//                                                               *
//   >>END-PRE-COMPILER<<                                        *
//===============================================================*
CTL-OPT DEBUG OPTION(*SRCSTMT: *NODEBUGIO);
CTL-OPT DECEDIT('0,') DATEDIT(*DMY.);
CTL-OPT DATFMT(*ISO) TIMFMT(*ISO);
CTL-OPT EXPROPTS(*RESDECPOS);
CTL-OPT EXTBININT(*YES);
//===============================================================*
//
// ------------------------------------
//  Type Definitions
// ------------------------------------
//
// ------------------------------------
//  External Prototypes
// ------------------------------------
/COPY QIFS2,CLIB 
/COPY QIFS2,PIFS2 
//
// ------------------------------------
//  Global Fields
// ------------------------------------
//
// ------------------------------------
//  Global Constants
// ------------------------------------
//
// ------------------------------------
//  Prototypes
// ------------------------------------
//
DCL-PR PGM_ENTRY_POINT EXTPGM('IFS2TEST11');
END-PR;
//
DCL-PR main;
END-PR;
//
//  Sends a message to QCMD
DCL-PR sndMsg;
  i_text VARCHAR(128) VALUE;
END-PR;
//
//  Program status data structure
DCL-DS sds QUALIFIED PSDS;
  pgmLib      CHAR(10) POS(81);
  pgmContProc CHAR(10) POS(334);
END-DS;
//
//===============================================================*
//  Program Entry Point
//===============================================================*
//
DCL-PI PGM_ENTRY_POINT;
END-PI;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main();

*inlr = *on;

return;

//
//===============================================================*
//  *** private ***
//  Sends a message to the caller.
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
  END-PI;
  //
  DCL-C HELLO_WORLD 'Hello World!';
  DCL-C BROWN_FOX 'The quick brown fox jumps over the lazy dog.';
  //
  //  Helper fields
  DCL-S i INT(10) INZ;
  DCL-S rc INT(10) INZ;
  DCL-S path1 LIKE(ifs_path_t) INZ;
  DCL-S path2 LIKE(ifs_path_t) INZ;
  DCL-S fd1 INT(10) INZ(-1);
  DCL-S fd2 INT(10) INZ(-1);
  DCL-S buffer1 VARCHAR(65535) INZ;
  DCL-S buffer2 VARCHAR(65535) INZ;
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
/COPY QIFS2,IFS1053  Datei stimmen nicht überein.
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


  dou '1';

    //-----------------------------------------------------
    //  Compare files of different sizes
    //-----------------------------------------------------
    path1 = ifsFile_getTempPath() + '.IFS2TEST11';
    fd1 = open(path1: O_CREAT + O_TRUNC + O_WRONLY + O_SHARE_RDONLY
                    : S_IRWXU + S_IRWXG + S_IRWXO);
    if (fd1 = -1);
      sndMsg(f_strError(f_errno()));
      leave;
    endif;

    path2 = ifsFile_getTempPath() + '.IFS2TEST11';
    fd2 = open(path2: O_CREAT + O_TRUNC + O_WRONLY + O_SHARE_RDONLY
                    : S_IRWXU + S_IRWXG + S_IRWXO);
    if (fd2 = -1);
      sndMsg(f_strError(f_errno()));
      leave;
    endif;

    buffer1 = HELLO_WORLD;
    buffer2 = BROWN_FOX;
    callp write(fd1: %addr(buffer1)+2: %len(buffer1));
    callp write(fd2: %addr(buffer2)+2: %len(buffer2));

    callp close(fd1);
    fd1 = -1;
    callp close(fd2);
    fd2 = -1;

    rc = ifsFile_compare(path1: path2: *omit: msg);
    if (rc <> cIFS_ERROR);
      sndMsg('Incorrect ''rc'' when comparing +
              files of different sizes');
      leave;
    endif;
    if (msg.ID <> 'IFS1053');
      sndMsg('Incorrect ''msg.ID'' when comparing +
              files of different sizes');
      leave;
    endif;

    IFS1053 = msg.data;
    if (IFS10531 <> 1);
      sndMsg('Incorrect ''error code'' when comparing +
              files of different sizes');
      leave;
    endif;

    unlink(path1);
    unlink(path2);

    //-----------------------------------------------------
    //  Compare files of different content
    //-----------------------------------------------------
    path1 = ifsFile_getTempPath() + '.IFS2TEST11';
    fd1 = open(path1: O_CREAT + O_TRUNC + O_WRONLY + O_SHARE_RDONLY
                    : S_IRWXU + S_IRWXG + S_IRWXO);
    if (fd1 = -1);
      sndMsg(f_strError(f_errno()));
      leave;
    endif;

    path2 = ifsFile_getTempPath() + '.IFS2TEST11';
    fd2 = open(path2: O_CREAT + O_TRUNC + O_WRONLY + O_SHARE_RDONLY
                    : S_IRWXU + S_IRWXG + S_IRWXO);
    if (fd2 = -1);
      sndMsg(f_strError(f_errno()));
      leave;
    endif;

    buffer1 = BROWN_FOX;
    %subst(buffer1: 10: %len(HELLO_WORLD)) = HELLO_WORLD;
    buffer2 = BROWN_FOX;
    callp write(fd1: %addr(buffer1)+2: %len(buffer1));
    callp write(fd2: %addr(buffer2)+2: %len(buffer2));

    callp close(fd1);
    fd1 = -1;
    callp close(fd2);
    fd2 = -1;

    rc = ifsFile_compare(path1: path2: *omit: msg);
    if (rc <> cIFS_ERROR);
      sndMsg('Incorrect ''rc'' when comparing +
              files of different sizes');
      leave;
    endif;
    if (msg.ID <> 'IFS1053');
      sndMsg('Incorrect ''msg.ID'' when comparing +
              files of different sizes');
      leave;
    endif;

    IFS1053 = msg.data;
    if (IFS10531 <> 2);
      sndMsg('Incorrect ''error code'' when comparing +
              files of different sizes');
      leave;
    endif;

    unlink(path1);
    unlink(path2);


    //-----------------------------------------------------
    //  Compare files with same content
    //-----------------------------------------------------
    path1 = ifsFile_getTempPath() + '.IFS2TEST11';
    fd1 = open(path1: O_CREAT + O_TRUNC + O_WRONLY + O_SHARE_RDONLY
                    : S_IRWXU + S_IRWXG + S_IRWXO);
    if (fd1 = -1);
      sndMsg(f_strError(f_errno()));
      leave;
    endif;

    path2 = ifsFile_getTempPath() + '.IFS2TEST11';
    fd2 = open(path2: O_CREAT + O_TRUNC + O_WRONLY + O_SHARE_RDONLY
                    : S_IRWXU + S_IRWXG + S_IRWXO);
    if (fd2 = -1);
      sndMsg(f_strError(f_errno()));
      leave;
    endif;

    buffer1 = BROWN_FOX;
    buffer2 = BROWN_FOX;

    for i = 1 to 10000;
      callp write(fd1: %addr(buffer1)+2: %len(buffer1));
      callp write(fd2: %addr(buffer2)+2: %len(buffer2));
    endfor;

    callp close(fd1);
    fd1 = -1;
    callp close(fd2);
    fd2 = -1;

    rc = ifsFile_compare(path1: path2: *omit: msg);
    if (rc <> cIFS_ERROR);
      sndMsg('Incorrect ''rc'' when comparing +
              files of different sizes');
      leave;
    endif;
    if (msg.ID <> 'IFS1053');
      sndMsg('Incorrect ''msg.ID'' when comparing +
              files of different sizes');
      leave;
    endif;

    IFS1053 = msg.data;
    if (IFS10531 <> 2);
      sndMsg('Incorrect ''error code'' when comparing +
              files of different sizes');
      leave;
    endif;

    unlink(path1);
    unlink(path2);

  enddo;

  if (fd1 > 0);
    callp close(fd1);
    fd1 = -1;
  endif;

  if (fd2 > 0);
    callp close(fd2);
    fd2 = -1;
  endif;

  unlink(path1);
  unlink(path2);

  return;

//
END-PROC MAIN;
//
