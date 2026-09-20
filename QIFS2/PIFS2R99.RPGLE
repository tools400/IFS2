 DEF  /IF NOT DEFINED(PIFS2R99)                                                               RADDAT
 DEF  /DEFINE PIFS2R99                                                                        RADDAT
     *                                                                                       RADDAT
     * --------------------------------                                                      RADDAT
     *  Imported prototypes                                                                  RADDAT
     * --------------------------------                                                      RADDAT
CPY  /COPY QIFS2,PIFS2                           Stream File and Directory                  RADDAT
CPY  /COPY QIFS2,CLIB                            C Runtime Library                          RADDAT
     *                                                                                       RADDAT
     * --------------------------------                                                      RADDAT
     *  Exported procedures                                                                  RADDAT
     * --------------------------------                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns cTrue, if a given file information structure belongs to a                    RADDAT
     *  symbolic link.                                                                       RADDAT
     D STAT_isSymbolicLink...                                                                 RADDAT
     D                 PR              N                                                      RADDAT
     D                                     extproc('IFS2R99+                                  RADDAT
     D                                     _STAT_isSymbolicLink+                              RADDAT
     D                                     ')                                                 RADDAT
     D  i_st_stat                          value  likeds(st_stat_t )                          RADDAT
     *                                                                                       RADDAT
     *  Returns cTrue, if a given file information structure belongs to a                    RADDAT
     *  directory.                                                                           RADDAT
     D STAT_isDirectory...                                                                    RADDAT
     D                 PR              N                                                      RADDAT
     D                                     extproc('IFS2R99+                                  RADDAT
     D                                     _STAT_isDirectory+                                 RADDAT
     D                                     ')                                                 RADDAT
     D  i_st_stat                          value  likeds(st_stat_t )                          RADDAT
     *                                                                                       RADDAT
     *  Returns cTrue, if a given file information structure belongs to a                    RADDAT
     *  file.                                                                                RADDAT
     D STAT_isFile...                                                                         RADDAT
     D                 PR              N                                                      RADDAT
     D                                     extproc('IFS2R99+                                  RADDAT
     D                                     _STAT_isFile+                                      RADDAT
     D                                     ')                                                 RADDAT
     D  i_st_stat                          value  likeds(st_stat_t )                          RADDAT
     *                                                                                       RADDAT
     *  Produces a new 'Qlg_Path_Name_t' structure.                                          RADDAT
     D QLG_PATH_new...                                                                        RADDAT
     D                 PR                         likeds(Qlg_Path_Name_t)                     RADDAT
     D                                     extproc('IFS2R99+                                  RADDAT
     D                                     _QLG_PATH_new+                                     RADDAT
     D                                     ')                                                 RADDAT
     D  i_path                             const  like(ifs_path_t  )                          RADDAT
     D                                            options(*varsize)                           RADDAT
     *                                                                                       RADDAT
     *  Returns cTrue if a given file name matches a given pattern.                          RADDAT
     D File_matchesPattern...                                                                 RADDAT
     D                 PR              N                                                      RADDAT
     D                                     extproc('IFS2R99+                                  RADDAT
     D                                     _File_matchesPattern+                              RADDAT
     D                                     ')                                                 RADDAT
     D  i_file                             const  like(ifs_path_t  )                          RADDAT
     D                                            options(*varsize)                           RADDAT
     D  i_pattern                          const  like(ifs_path_t  )                          RADDAT
     D                                            options(*varsize)                           RADDAT
     *                                                                                       RADDAT
     *  Retrieves a file attribute of type: time                                             RADDAT
     D FileAttr_getTime...                                                                    RADDAT
     D                 PR            10I 0                                                    RADDAT
     D                                     extproc('IFS2R99+                                  RADDAT
     D                                     _FileAttr_getTime+                                 RADDAT
     D                                     ')                                                 RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D i_attr                        10I 0 const                                              RADDAT
     D o_time                          Z                                                      RADDAT
     *                                                                                       RADDAT
     *  Converts a timestamp from Epoch to RPG format.                                       RADDAT
     D EpochTime_toTimestamp...                                                               RADDAT
     D                 PR              Z                                                      RADDAT
     D                                     extproc('IFS2R99+                                  RADDAT
     D                                     _EpochTime_toTimestamp+                            RADDAT
     D                                     ')                                                 RADDAT
     D i_epochTmStmp                 10I 0 value                                              RADDAT
     *                                                                                       RADDAT
     *  Initializes code conversion.                                                         RADDAT
     D Iconv_initialize...                                                                    RADDAT
     D                 PR                         likeds(iconv_t  )                           RADDAT
     D                                     extproc('IFS2R99+                                  RADDAT
     D                                     _Iconv_initialize+                                 RADDAT
     D                                     ')                                                 RADDAT
     D  i_fromCcsid                  10U 0 value                                              RADDAT
     D  i_toCcsid                    10U 0 value                                              RADDAT
     *                                                                                       RADDAT
     *  Terminatess code conversion.                                                         RADDAT
     D Iconv_terminate...                                                                     RADDAT
     D                 PR                                                                     RADDAT
     D                                     extproc('IFS2R99+                                  RADDAT
     D                                     _Iconv_terminate+                                  RADDAT
     D                                     ')                                                 RADDAT
     D  io_hIconv                                 likeds(iconv_t  )                           RADDAT
     *                                                                                       RADDAT
 DEF  /ENDIF                                                                                  RADDAT
