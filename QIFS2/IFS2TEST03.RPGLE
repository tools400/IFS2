     *===============================================================*                       RADDAT
     *  Test: Create / Read / Remove temp. directory tree            *                       RADDAT
     *---------------------------------------------------------------*                       RADDAT
     *    CALL PGM(IFS2TEST03) // using a temp. directory in '/tmp'  *                       RADDAT
     *    CALL PGM(IFS2TEST03) PARM('/home/raddatz/test_ifs/*')      *                       RADDAT
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
     FQSYSPRT   O    F  132        PRINTER oflind(*INOF)                                      RADDAT
     F                                     usropn                                             RADDAT
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  Type Definitions                                                                     RADDAT
     * ------------------------------------                                                  RADDAT
     D resultSet_t     DS                  based(pDummy)   qualified                          RADDAT
     D  selectedPath                       like(ifs_path_t)
     D  msg                                likeds(msg_t   )
     D  numE                         10I 0                                                    RADDAT
     D  entry                              likeds(entry_t) dim(10)
     *                                                                                       RADDAT
     D entry_t         DS                  based(pDummy)   qualified                          RADDAT
     D  type                               like(ifs_type_t)
     D  path                               like(ifs_path_t)
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
     D                 PR                         extpgm('IFS2TEST03')                        RADDAT
     D  gi_dir                       32A   const  options(*nopass)                            RADDAT
     *                                                                                       RADDAT
     D main...                                                                                RADDAT
     D                 PR                                                                     RADDAT
     D  i_dir                              value  like(ifs_path_t )                           RADDAT
     D                                            options(*trim)                              RADDAT
     *                                                                                       RADDAT
     *  Creates some files in a given directory.                                             RADDAT
     D createFiles...                                                                         RADDAT
     D                 PR                                                                     RADDAT
     D  i_dir                              value  like(ifs_path_t )                           RADDAT
     D  i_level                      10I 0 value                                              RADDAT
     *                                                                                       RADDAT
     *  Prints a line                                                                        RADDAT
     D print...                                                                               RADDAT
     D                 PR                                                                     RADDAT
     D  i_line                             value  like(g_PrintLine)                           RADDAT
     *                                                                                       RADDAT
     *  Produces a directory tree including files and subdirectories.                        RADDAT
     D createDirectoryTree...                                                                 RADDAT
     D                 PR                                                                     RADDAT
     D  i_dir                              value  like(ifs_path_t )                           RADDAT
     D  i_level                      10I 0 value                                              RADDAT
     D  i_options                    10I 0 value                                              RADDAT
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
     D  gi_dir                       32A   const  options(*nopass)                            RADDAT
     *                                                                                       RADDAT
     D g_dir           S                   like(ifs_path_t ) inz                              RADDAT
     D g_PrintLine     S            132A                     inz                              RADDAT
     * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                         RADDAT
      /FREE
                                                                                            //RADDAT
 B01     if (%parms() >= 1);                                                                //RADDAT
            main(gi_dir);                                                                   //RADDAT
 X01     else;                                                                              //RADDAT
            g_dir = ifsFile_getTempPath();                                                  //RADDAT
            g_dir = ifsPath_getDirectory(g_dir) +
                    'ifs2_' + ifsPath_getName(g_dir);                                       //RADDAT
            main(g_dir);                                                                    //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         *inlr = *on;                                                                       //RADDAT
                                                                                            //RADDAT
         return;                                                                            //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
     *===============================================================*                       RADDAT
     *  Printer output                                                                       RADDAT
     *===============================================================*                       RADDAT
     OQSYSPRT   E                                                                             RADDAT
     O                       g_PrintLine        132A                                          RADDAT
     *                                                                                       RADDAT
     *===============================================================*                       RADDAT
     *  Prints a line.                                                                       RADDAT
     *===============================================================*                       RADDAT
    P print...                                                                               RADDAT
    P                 B                                                                      RADDAT
     *                                                                                       RADDAT
     D print...                                                                               RADDAT
     D                 PI                                                                     RADDAT
     D  i_line                             value  like(g_PrintLine)                           RADDAT
     * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                         RADDAT
      /FREE
                                                                                            //RADDAT
         g_PrintLine = i_line;                                                              //RADDAT
         except;                                                                            //RADDAT
                                                                                            //RADDAT
         return;                                                                            //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P print...                                                                               RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *===============================================================*                       RADDAT
     *  Creates some files in a given directory.                                             RADDAT
     *===============================================================*                       RADDAT
    P createFiles...                                                                         RADDAT
    P                 B                                                                      RADDAT
     *                                                                                       RADDAT
     D createFiles...                                                                         RADDAT
     D                 PI                                                                     RADDAT
     D  i_dir                              value  like(ifs_path_t )                           RADDAT
     D  i_level                      10I 0 value                                              RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D rc              S             10I 0 inz                                                RADDAT
     D numFiles        S             10I 0 inz                                                RADDAT
     D file            S                   like(ifs_path_t ) inz                              RADDAT
     D hFile           S                   like(ifs_hFile_t) inz                              RADDAT
     D msg             DS                  likeds(msg_t    ) inz                              RADDAT
     *                                                                                       RADDAT
     D FILES_MAX       C                   10                                                 RADDAT
     * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                         RADDAT
      /FREE
                                                                                            //RADDAT
         numFiles = %int(FILES_MAX / RAND_MAX * rand());                                    //RADDAT
                                                                                            //RADDAT
 B01     dow (numFiles > 0);                                                                //RADDAT
                                                                                            //RADDAT
            file = i_dir + 'ifs2_tmpFile_' + %char(i_level ) + '_'
                                           + %char(numFiles) + '.txt';                      //RADDAT
            hFile = ifsFile_open(file
                                 : O_RDWR + O_SHARE_RDONLY +
                                   O_CREAT + O_EXCL + O_CCSID + O_TEXTDATA
                                 : 1252
                                 : S_IRWXU + S_IRWXG + S_IRWXO
                                 : msg);                                                    //RADDAT
            p_assert(msg.ID = cMSG_ID_OK: 'Unexpected: msg.ID=' + msg.ID);                  //RADDAT
                                                                                            //RADDAT
            ifsFile_writeLine(hFile
                  : 'This is a test file create by the IFS2 utility.': 0);                  //RADDAT
            ifsFile_writeLine(hFile
                  : 'It has been created by program: ' +
                     f_objName(sds.pgmContProc: sds.pgmLib): 0);                            //RADDAT
                                                                                            //RADDAT
            rc = ifsFile_close(hFile: msg);                                                 //RADDAT
            p_assert(rc = cIFS_OK: 'Unexpected: rc=' + %char(rc));                          //RADDAT
            p_assert(msg.ID = cMSG_ID_OK: 'Unexpected: msg.ID=' + msg.ID);                  //RADDAT
                                                                                            //RADDAT
            numFiles = numFiles - 1;                                                        //RADDAT
 E01     enddo;                                                                             //RADDAT
                                                                                            //RADDAT
         p_assert(file  = '' and ifsDirectory_isEmpty(i_dir) or
                  file <> '' and not ifsDirectory_isEmpty(i_dir));                          //RADDAT
                                                                                            //RADDAT
         return;                                                                            //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P createFiles...                                                                         RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *===============================================================*                       RADDAT
     *  Produces a directory tree including files and subdirectories.                        RADDAT
     *===============================================================*                       RADDAT
    P createDirectoryTree...                                                                 RADDAT
    P                 B                                                                      RADDAT
     *                                                                                       RADDAT
     D createDirectoryTree...                                                                 RADDAT
     D                 PI                                                                     RADDAT
     D  i_dir                              value  like(ifs_path_t )                           RADDAT
     D  i_level                      10I 0 value                                              RADDAT
     D  i_options                    10I 0 value                                              RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D rc              S             10I 0 inz                                                RADDAT
     D msg             DS                  likeds(msg_t      ) inz                            RADDAT
     * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                         RADDAT
      /FREE
                                                                                            //RADDAT
 B01     if (i_level > 3);                                                                  //RADDAT
            return;                                                                         //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         rc = ifsDirectory_create(i_dir: i_options: *: msg);                                //RADDAT
                                                                                            //RADDAT
         p_assert(rc = cIFS_OK: 'Unexpected: rc=' + %char(rc));                             //RADDAT
         p_assert(msg.ID = cMSG_ID_OK: 'Unexpected: msg.ID=' + msg.ID);                     //RADDAT
                                                                                            //RADDAT
         createFiles(i_dir: i_level);                                                       //RADDAT
                                                                                            //RADDAT
         createDirectoryTree(i_dir + 'subDirectory_' + %char(i_level + 1) + '/'
                             : i_level + 1
                             : cIFS_MKDIR_DFT);                                             //RADDAT
                                                                                            //RADDAT
         return;                                                                            //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P createDirectoryTree...                                                                 RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *===============================================================*                       RADDAT
     *  Callback to process directory entries.                                               RADDAT
     *===============================================================*                       RADDAT
    P ifsDirectory_read_Dirent...                                                            RADDAT
    P                 B                                                                      RADDAT
     *                                                                                       RADDAT
     D ifsDirectory_read_Dirent...                                                            RADDAT
     D                 PI              N                                                      RADDAT
     D  i_level                      10I 0 const                                              RADDAT
     D  i_directory                        const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D  i_dirent                           const  likeds(dirent_t    )                        RADDAT
     D  i_type                             const  like(ifs_type_t    )                        RADDAT
     D  i_pUserData                    *   const                                              RADDAT
     D  o_msg                                     likeds(msg_t       )                        RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D  path           S                   like(ifs_path_t  ) inz                             RADDAT
     * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                         RADDAT
      /FREE
                                                                                            //RADDAT
         path = i_directory + f_left(i_dirent.d_name: i_dirent.d_namelen);                  //RADDAT
                                                                                            //RADDAT
         print(f_space(2 * i_level) + '[' + %trim(i_type) + '] ' + path +
               ' (x''' + ifsFile_getID(path) + ''')');                                      //RADDAT
                                                                                            //RADDAT
                                                                                            //RADDAT
         return cIFS_CONTINUE;                                                              //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P ifsDirectory_read_Dirent...                                                            RADDAT
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
     D  i_dir                              value  like(ifs_path_t )                           RADDAT
     D                                            options(*trim)                              RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D rc              S             10I 0 inz                                                RADDAT
     D rc1             S             10I 0 inz                                                RADDAT
     D rc2             S             10I 0 inz                                                RADDAT
     D homeDir         S                   like(ifs_path_t   ) inz                            RADDAT
     D msg             DS                  likeds(msg_t      ) inz                            RADDAT
     * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                         RADDAT
      /FREE
                                                                                            //RADDAT
         //-----------------------------------------------------                           //RADDAT
         //  Initialize pseudo random number generator                                     //RADDAT
         //-----------------------------------------------------                           //RADDAT
         srand(time(*NULL));                                                                //RADDAT
                                                                                            //RADDAT
         //-----------------------------------------------------                           //RADDAT
         //  Produce a directory tree                                                      //RADDAT
         //-----------------------------------------------------                           //RADDAT
         i_dir = ifsDirectory_fixSyntax(i_dir);                                             //RADDAT
                                                                                            //RADDAT
 B01     if (ifsDirectory_exist(i_dir));                                                    //RADDAT
            i_dir = f_left(i_dir: %len(i_dir)-1);                                           //RADDAT
            homeDir = i_dir + ifsFile_getTempPath() + '/';                                  //RADDAT
            createDirectoryTree(homeDir: 1: cIFS_MKDIR_SUBDIR);                             //RADDAT
 X01     else;                                                                              //RADDAT
            homeDir = i_dir;                                                                //RADDAT
            createDirectoryTree(homeDir: 1: cIFS_MKDIR_DFT);                                //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT

         //-----------------------------------------------------
         //  Print directory structure                                                     //RADDAT
         //-----------------------------------------------------
         open QSYSPRT;                                                                      //RADDAT
                                                                                            //RADDAT
 B01     if (f_endsWith('/': homeDir));                    //Remove trailing SLASH         //RADDAT
            homeDir = f_left(homeDir: %len(homeDir) - 1);  //to read the higher directory  //RADDAT
 E01     endif;                                            //using the directory we just   //RADDAT
                                                           //created as the pattern.       //RADDAT
         rc1 = ifsDirectory_read(homeDir
                                 : %paddr('ifsDirectory_read_Dirent')
                                 : cIFS_READDIR_CB_DIRENT
                                   + cIFS_READDIR_DIRECTORY
                                   + cIFS_READDIR_FILE
                                   + cIFS_READDIR_SUBDIRECTORY
                                 : *NULL
                                 : msg);                                                    //RADDAT
         p_assert(rc1 > 0: 'Unexpected: rc1=' + %char(rc1));                                //RADDAT
         p_assert(msg.ID = cMSG_ID_OK: 'Unexpected: msg.ID=' + msg.ID);                     //RADDAT
                                                                                            //RADDAT
         close QSYSPRT;                                                                     //RADDAT
                                                                                            //RADDAT
         //-----------------------------------------------------                           //RADDAT
         //  Rename directory structure                                                    //RADDAT
         //-----------------------------------------------------                           //RADDAT
         rc = ifsDirectory_rename(homeDir
                                  : ifsPath_getName(homeDir) + '.renamed'
                                  : msg);                                                   //RADDAT
         p_assert(rc = cIFS_OK
                  : 'Expected cIFS_OK from ifsDirectory_rename()');                         //RADDAT
         p_assert(msg.ID = cMSG_ID_OK
                  : 'Expected msg ID cMSG_ID_OK when renaming an +
                     existing directory');                                                  //RADDAT
                                                                                            //RADDAT
         //-----------------------------------------------------                           //RADDAT
         //  Delete directory structure                                                    //RADDAT
         //-----------------------------------------------------                           //RADDAT
         rc2 = ifsDirectory_remove(homeDir + '.renamed'
                                   : cIFS_RMDIR_DELETE_SUB_DIRECTORIES: msg);               //RADDAT
         p_assert(rc2 > 0: 'Unexpected: rc2=' + %char(rc2));                                //RADDAT
         p_assert(msg.ID = cMSG_ID_OK: 'Unexpected: msg.ID=' + msg.ID);                     //RADDAT
         p_assert(rc1 = rc2: 'Number of created entries does not match +
                              number of deleted entries: ' +
                              %char(rc1) + '/' + %char(rc2));                               //RADDAT
                                                                                            //RADDAT
         return;                                                                            //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P main...                                                                                RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
