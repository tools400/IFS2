     *===============================================================*                       RADDAT
     *  Test: Create/WriteLine/ReadLine/Delete stream file           *                       RADDAT
     *---------------------------------------------------------------*                       RADDAT
     *    CALL PGM(IFS2TEST02) // using a temp. object name          *                       RADDAT
     *    CALL PGM(IFS2TEST02) PARM('/home/raddatz/tmpFileName')     *                       RADDAT
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
CPY  /COPY QIFS2,PIFS2                                                                      RADDAT
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  Global Fields                                                                        RADDAT
     * ------------------------------------                                                  RADDAT
     D line_t          S            256A   varying                                            RADDAT
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  Global Constants                                                                     RADDAT
     * ------------------------------------                                                  RADDAT
     D NUM_LINES       C                   41                                                 RADDAT
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  Prototypes                                                                           RADDAT
     * ------------------------------------                                                  RADDAT
     *                                                                                       RADDAT
     D PGM_ENTRY_POINT...                                                                     RADDAT
     D                 PR                         extpgm('IFS2TEST02')                        RADDAT
     D  gi_path                      32A   const  options(*nopass)                            RADDAT
     *                                                                                       RADDAT
     D main...                                                                                RADDAT
     D                 PR                                                                     RADDAT
     D  i_path                             value  like(ifs_path_t )                           RADDAT
     D                                            options(*trim)                              RADDAT
     *                                                                                       RADDAT
     D getLines...                                                                            RADDAT
     D                 PR                         like(line_t) dim(NUM_LINES)                 RADDAT
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
     *  Initializes data to be written to a stream file.                                     RADDAT
     *===============================================================*                       RADDAT
    P getLines...                                                                            RADDAT
    P                 B                                                                      RADDAT
     *                                                                                       RADDAT
     D getLines...                                                                            RADDAT
     D                 PI                         like(line_t) dim(NUM_LINES)                 RADDAT
     *                                                                                       RADDAT
     D line            S                   like(line_t      ) inz                             RADDAT
     D                                     dim(NUM_LINES)                                     RADDAT
     * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                         RADDAT
      /FREE
                                                                                            //RADDAT
         //-----------------------------------------------------------                     //RADDAT
         //   All Chris De Burgh lyrics are copyright by their                             //RADDAT
         //   rightful owner(s).                                                           //RADDAT
         //-----------------------------------------------------------                     //RADDAT
                                                                                            //RADDAT
         line( 1) = 'Chris de Burgh: A Spaceman Came Travelling';                           //RADDAT
         line( 2) = '';                                                                     //RADDAT
         line( 3) = 'A spaceman came travelling on his ship from afar,';                    //RADDAT
         line( 4) = 'Twas light years of time since his mission did start,';                //RADDAT
         line( 5) = 'And over a village he halted his craft,';                              //RADDAT
         line( 6) = 'And it hung in the sky like a star, just like a star...';              //RADDAT
         line( 7) = '';                                                                     //RADDAT
         line( 8) = 'He followed a light and came down to a shed,';                         //RADDAT
         line( 9) = 'Where a mother and child were lying there on a bed,';                  //RADDAT
         line(10) = 'A bright light of silver shone round his head,';                       //RADDAT
         line(11) = 'And he had the face of an angle, and they were afraid...';             //RADDAT
         line(12) = '';                                                                     //RADDAT
         line(13) = 'Then the stranger spoke, he said "Do not fear,';                       //RADDAT
         line(14) = 'I come from a planet a long way from here,';                           //RADDAT
         line(15) = 'And I bring a message for mankind to hear,"';                          //RADDAT
         line(16) = 'And suddenly the sweetest music filled the air...';                    //RADDAT
         line(17) = '';                                                                     //RADDAT
         line(18) = 'And it went La La....';                                                //RADDAT
         line(19) = 'Peace and goodwill to all men, and love for the child...';             //RADDAT
         line(20) = '';                                                                     //RADDAT
         line(21) = 'This lovely music went trembling through the ground,';                 //RADDAT
         line(22) = 'And many were wakened on hearing that sound,';                         //RADDAT
         line(23) = 'And travellers on the road, the village they found,';                  //RADDAT
         line(24) =
              'By the light of that ship in the sky, which shone all round...';             //RADDAT
         line(25) = '';                                                                     //RADDAT
         line(26) = 'And just before dawn at the paling of the sky,';                       //RADDAT
         line(27) = 'The stranger returned and said "Now I must fly,';                      //RADDAT
         line(28) = 'When two thousand years of your time has gone by,';                    //RADDAT
         line(29) = 'This song will begin once again, to a baby''s cry..."';                //RADDAT
         line(30) = '';                                                                     //RADDAT
         line(31) = 'And it went La La ... This song will begin once again';                //RADDAT
         line(32) = 'To a baby''s cry...';                                                  //RADDAT
         line(33) = 'And it goes La La... Peace and goodwill to all men, and';              //RADDAT
         line(34) = 'Love for the child...d...';                                            //RADDAT
         line(35) =
              'Oh the whole world is waiting, waiting to hear the song again,';             //RADDAT
         line(36) = 'There are thousands standing on the edge of the world,';               //RADDAT
         line(37) = 'And a star is moving somewhere, the time is nearly here,';             //RADDAT
         line(38) = 'This song will begin once again, to a baby''s cry...';                 //RADDAT
                                                                                            //RADDAT
         //Test reading a line that contains an incomplete EOL character                   //RADDAT
         line(39) = '------------'+ %subst(cIFS_EOL_CRLF: 1: 1) +'------------';            //RADDAT
                                                                                            //RADDAT
         line(40) = 'All Chris De Burgh lyrics are copyright by their';                     //RADDAT
         line(41) = 'rightful owner(s).';                                                   //RADDAT
                                                                                            //RADDAT
         return line;                                                                       //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P getLines...                                                                            RADDAT
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
     D hFile           S                   like(ifs_hFile_t ) inz                             RADDAT
     D x               S             10I 0                    inz                             RADDAT
     D rc              S             10I 0                    inz                             RADDAT
     D path            S                   like(ifs_path_t  ) inz                             RADDAT
     D bytesWritten    S             10I 0                    inz                             RADDAT
     D bytesRed        S             10I 0                    inz                             RADDAT
     D buffer          S            256A                      inz(*ALLx'00')                  RADDAT
     D msg             DS                  likeds(msg_t     ) inz                             RADDAT
     *                                                                                       RADDAT
     D line            S                   like(line_t      ) inz                             RADDAT
     D                                     dim(NUM_LINES)                                     RADDAT
     * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                         RADDAT
      /FREE
                                                                                            //RADDAT
         path = ifsPath_fixSyntax(%trimR(i_path));                                          //RADDAT
                                                                                            //RADDAT
 B01     dou '1';                                                                           //RADDAT
                                                                                            //RADDAT
            line = getLines();                                                              //RADDAT
                                                                                            //RADDAT
            //Open IFS file (The file must not yet exists!)                                //RADDAT
            //Open flags:     read & write                                                 //RADDAT
            //                share with writers (= use temp buffer)                       //RADDAT
            //                create file, send message if file exists                     //RADDAT
            //                open for text data                                           //RADDAT
            hFile = ifsFile_open(path
                                 : O_RDWR + O_SHARE_RDWR +
                                   O_CREAT + O_EXCL + O_TEXTDATA
                                 : *
                                 : *
                                 : msg);                                                    //RADDAT
                                                                                            //RADDAT
            p_assert(msg.ID = cMSG_ID_OK
                     : 'Expected cMSG_ID_OK to be returned by ifsFile_open()');             //RADDAT
                                                                                            //RADDAT
            //Write lines to stream file                                                   //RADDAT
 B02        for x = 1 to %elem(line);                                                       //RADDAT
               bytesWritten = ifsFile_writeLine(hFile
                                                : %addr(line(x)) + 2
                                                : %len(line(x))
                                                : cIFS_EOL_CRLF);                           //RADDAT
               p_assert(bytesWritten = %len(line(x))
                        : 'Number of bytes written +
                           does not match expected value');                                 //RADDAT
 E02        endfor;                                                                         //RADDAT
                                                                                            //RADDAT
            ifsFile_close(hFile);                                                           //RADDAT
                                                                                            //RADDAT
            //Open IFS file (The file must exists!)                                        //RADDAT
            //Open flags:     read                                                         //RADDAT
            //                share with readers                                           //RADDAT
            //                open for text data                                           //RADDAT
            hFile = ifsFile_open(path
                                 : O_RDONLY + O_SHARE_RDONLY +
                                   O_TEXTDATA
                                 : *
                                 : *
                                 : msg);                                                    //RADDAT
                                                                                            //RADDAT
            p_assert(msg.ID = cMSG_ID_OK
                     : 'Expected cMSG_ID_OK to be returned by ifsFile_open()');             //RADDAT
                                                                                            //RADDAT
            //Read lines until EOF                                                         //RADDAT
            reset buffer;                                                                   //RADDAT
            x = 1;                                                                          //RADDAT
            bytesRed = ifsFile_readLine(hFile
                                        : %addr(buffer)
                                        : %size(buffer)
                                        : cIFS_EOL_CRLF
                                        : msg);                                             //RADDAT
                                                                                            //RADDAT
 B02        dow (bytesRed <> cIFS_EOF);                                                     //RADDAT
               p_assert(bytesRed = %len(line(x))
                        : 'Number of bytes red +
                           does not match expected value');                                 //RADDAT
               p_assert(%str(%addr(buffer)) = line(x)
                        : 'Buffer data does not match line(' + %char(x) + ')');             //RADDAT
               reset buffer;                                                                //RADDAT
                                                                                            //RADDAT
               x = x + 1;                                                                   //RADDAT
               bytesRed = ifsFile_readLine(hFile
                                           : %addr(buffer)
                                           : %size(buffer)
                                           : cIFS_EOL_CRLF
                                           : msg);                                          //RADDAT
 E02        enddo;                                                                          //RADDAT
                                                                                            //RADDAT
            //Close IFS file                                                               //RADDAT
            ifsFile_close(hFile);                                                           //RADDAT
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
