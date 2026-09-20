 DEF  /IF NOT DEFINED(PIFS2R04)                                                               RADDAT
 DEF  /DEFINE PIFS2R04                                                                        RADDAT
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
     *  Creates an application message.                                                      RADDAT
     D AppMsg_new...                                                                          RADDAT
     D                 PR                         likeds(msg_t     )                          RADDAT
     D                                     extproc('IFS2R04+                                  RADDAT
     D                                     _AppMsg_new+                                       RADDAT
     D                                     ')                                                 RADDAT
     D  i_ID                               const  like(msg_t.ID    )                          RADDAT
     D  i_data                             const  like(msg_t.data  )                          RADDAT
     D                                            options(*nopass)                            RADDAT
     D  i_type                             const  like(msg_t.data  )                          RADDAT
     D                                            options(*nopass)                            RADDAT
     *                                                                                       RADDAT
     *  Creates an application ESCAPE message.                                               RADDAT
     D AppMsg_newEscape...                                                                    RADDAT
     D                 PR                         likeds(msg_t     )                          RADDAT
     D                                     extproc('IFS2R04+                                  RADDAT
     D                                     _AppMsg_newEscape+                                 RADDAT
     D                                     ')                                                 RADDAT
     D  i_ID                               const  like(msg_t.ID    )                          RADDAT
     D  i_data                             const  like(msg_t.data  )                          RADDAT
     D                                            options(*nopass)                            RADDAT
     *                                                                                       RADDAT
 DEF  /ENDIF                                                                                  RADDAT
