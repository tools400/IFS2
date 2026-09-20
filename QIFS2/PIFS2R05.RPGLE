 DEF  /IF NOT DEFINED(PIFS2R05)                                                               RADDAT
 DEF  /DEFINE PIFS2R05                                                                        RADDAT
     *                                                                                       RADDAT
     * --------------------------------                                                      RADDAT
     *  Imported prototypes                                                                  RADDAT
     * --------------------------------                                                      RADDAT
CPY  /COPY QBASICS1,PBASICS1                     Tools/400 Runtime Library                  RADDAT
     *                                                                                       RADDAT
     * --------------------------------                                                      RADDAT
     *  Exported procedures                                                                  RADDAT
     * --------------------------------                                                      RADDAT
     *                                                                                       RADDAT
     *  Kills the IFS service program by sending a given ESCAPE message.                     RADDAT
     D Application_killWithMsg...                                                             RADDAT
     D                 PR                                                                     RADDAT
     D                                     extproc('IFS2R05+                                  RADDAT
     D                                     _Application_killWithMsg+                          RADDAT
     D                                     ')                                                 RADDAT
     D  i_msg                              value  likeds(msg_t    )                           RADDAT
     *                                                                                       RADDAT
 DEF  /ENDIF                                                                                  RADDAT
