**FREE
//===============================================================*
//  Test: Create/WriteLine/ReadLine/Delete stream file           *
//---------------------------------------------------------------*
//    CALL PGM(IFS2TEST02) // using a temp. object name          *
//    CALL PGM(IFS2TEST02) PARM('/home/raddatz/tmpFileName')     *
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
/COPY QIFS2,PIFS2 
//
// ------------------------------------
//  Global Fields
// ------------------------------------
DCL-S line_t VARCHAR(256);
//
// ------------------------------------
//  Global Constants
// ------------------------------------
DCL-C NUM_LINES 41;
//
// ------------------------------------
//  Prototypes
// ------------------------------------
//
DCL-PR PGM_ENTRY_POINT EXTPGM('IFS2TEST02');
  gi_path CHAR(32) CONST OPTIONS(*NOPASS);
END-PR;
//
DCL-PR main;
  i_path VALUE LIKE(ifs_path_t) OPTIONS(*TRIM);
END-PR;
//
DCL-PR getLines LIKE(line_t) DIM(NUM_LINES);
END-PR;
//
//===============================================================*
//  Program Entry Point
//===============================================================*
//
DCL-PI PGM_ENTRY_POINT;
  gi_path CHAR(32) CONST OPTIONS(*NOPASS);
END-PI;
//
DCL-S g_path LIKE(ifs_path_t) INZ;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (%parms() >= 1);
  main(gi_path);
else;
  g_path = ifsFile_getTempPath();
  g_path = ifsPath_getDirectory(g_path) +
           'ifs2_' + ifsPath_getName(g_path);
  main(g_path);
endif;

*inlr = *on;

return;

//
//===============================================================*
//  Initializes data to be written to a stream file.
//===============================================================*
DCL-PROC getLines;
  //
  DCL-PI *N LIKE(line_t) DIM(NUM_LINES);
  END-PI;
  //
  DCL-S line LIKE(line_t) INZ DIM(NUM_LINES);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  //-----------------------------------------------------------
  //   All Chris De Burgh lyrics are copyright by their
  //   rightful owner(s).
  //-----------------------------------------------------------

  line( 1) = 'Chris de Burgh: A Spaceman Came Travelling';
  line( 2) = '';
  line( 3) = 'A spaceman came travelling on his ship from afar,';
  line( 4) = 'Twas light years of time since his mission did start,';
  line( 5) = 'And over a village he halted his craft,';
  line( 6) = 'And it hung in the sky like a star, just like a star...';
  line( 7) = '';
  line( 8) = 'He followed a light and came down to a shed,';
  line( 9) = 'Where a mother and child were lying there on a bed,';
  line(10) = 'A bright light of silver shone round his head,';
  line(11) = 'And he had the face of an angle, and they were afraid...';
  line(12) = '';
  line(13) = 'Then the stranger spoke, he said "Do not fear,';
  line(14) = 'I come from a planet a long way from here,';
  line(15) = 'And I bring a message for mankind to hear,"';
  line(16) = 'And suddenly the sweetest music filled the air...';
  line(17) = '';
  line(18) = 'And it went La La....';
  line(19) = 'Peace and goodwill to all men, and love for the child...';
  line(20) = '';
  line(21) = 'This lovely music went trembling through the ground,';
  line(22) = 'And many were wakened on hearing that sound,';
  line(23) = 'And travellers on the road, the village they found,';
  line(24) =
       'By the light of that ship in the sky, which shone all round...';
  line(25) = '';
  line(26) = 'And just before dawn at the paling of the sky,';
  line(27) = 'The stranger returned and said "Now I must fly,';
  line(28) = 'When two thousand years of your time has gone by,';
  line(29) = 'This song will begin once again, to a baby''s cry..."';
  line(30) = '';
  line(31) = 'And it went La La ... This song will begin once again';
  line(32) = 'To a baby''s cry...';
  line(33) = 'And it goes La La... Peace and goodwill to all men, and';
  line(34) = 'Love for the child...d...';
  line(35) =
       'Oh the whole world is waiting, waiting to hear the song again,';
  line(36) = 'There are thousands standing on the edge of the world,';
  line(37) = 'And a star is moving somewhere, the time is nearly here,';
  line(38) = 'This song will begin once again, to a baby''s cry...';

  //Test reading a line that contains an incomplete EOL character
  line(39) = '------------'+ %subst(cIFS_EOL_CRLF: 1: 1) +'------------';

  line(40) = 'All Chris De Burgh lyrics are copyright by their';
  line(41) = 'rightful owner(s).';

  return line;

//
END-PROC;
//
//===============================================================*
//  Main procedure
//===============================================================*
DCL-PROC main;
  //
  DCL-PI *N;
    i_path VALUE LIKE(ifs_path_t) OPTIONS(*TRIM);
  END-PI;
  //
  //  Helper fields
  DCL-S hFile LIKE(ifs_hFile_t) INZ;
  DCL-S x INT(10) INZ;
  DCL-S rc INT(10) INZ;
  DCL-S path LIKE(ifs_path_t) INZ;
  DCL-S bytesWritten INT(10) INZ;
  DCL-S bytesRed INT(10) INZ;
  DCL-S buffer CHAR(256) INZ(*ALLx'00');
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  DCL-S line LIKE(line_t) INZ DIM(NUM_LINES);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  path = ifsPath_fixSyntax(%trimR(i_path));

  dou '1';

    line = getLines();

    //Open IFS file (The file must not yet exists!)
    //Open flags:     read & write
    //                share with writers (= use temp buffer)
    //                create file, send message if file exists
    //                open for text data
    hFile = ifsFile_open(path
                         : O_RDWR + O_SHARE_RDWR +
                           O_CREAT + O_EXCL + O_TEXTDATA
                         : *omit
                         : *omit
                         : msg);

    p_assert(msg.ID = cMSG_ID_OK
             : 'Expected cMSG_ID_OK to be returned by ifsFile_open()');

    //Write lines to stream file
    for x = 1 to %elem(line);
      bytesWritten = ifsFile_writeLine(hFile
                                       : %addr(line(x)) + 2
                                       : %len(line(x))
                                       : cIFS_EOL_CRLF);
      p_assert(bytesWritten = %len(line(x))
               : 'Number of bytes written +
                  does not match expected value');
    endfor;

    ifsFile_close(hFile);

    //Open IFS file (The file must exists!)
    //Open flags:     read
    //                share with readers
    //                open for text data
    hFile = ifsFile_open(path
                         : O_RDONLY + O_SHARE_RDONLY +
                           O_TEXTDATA
                         : *omit
                         : *omit
                         : msg);

    p_assert(msg.ID = cMSG_ID_OK
             : 'Expected cMSG_ID_OK to be returned by ifsFile_open()');

    //Read lines until EOF
    reset buffer;
    x = 1;
    bytesRed = ifsFile_readLine(hFile
                                : %addr(buffer)
                                : %size(buffer)
                                : cIFS_EOL_CRLF
                                : msg);

    dow (bytesRed <> cIFS_EOF);
      p_assert(bytesRed = %len(line(x))
               : 'Number of bytes red +
                  does not match expected value');
      p_assert(%str(%addr(buffer)) = line(x)
               : 'Buffer data does not match line(' + %char(x) + ')');
      reset buffer;

      x = x + 1;
      bytesRed = ifsFile_readLine(hFile
                                  : %addr(buffer)
                                  : %size(buffer)
                                  : cIFS_EOL_CRLF
                                  : msg);
    enddo;

    //Close IFS file
    ifsFile_close(hFile);

  enddo;

  if (ifsFile_exist(path));
    rc = ifsFile_delete(path);
    p_assert(rc = cIFS_OK
             : 'Expected cIFS_ERROR from ifsFile_delete()');
  endif;

  return;

//
END-PROC MAIN;
//
