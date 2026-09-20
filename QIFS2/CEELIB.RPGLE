 DEF  /IF NOT DEFINED(CEELIB)                                                                 RADDAT
 DEF  /DEFINE CEELIB                                                                          RADDAT
     *                                                                                       RADDAT
     * ---------------------------------------------------------------                       RADDAT
     *   Program or Procedure Call APIs                                                      RADDAT
     * ---------------------------------------------------------------                       RADDAT
     *                                                                                       RADDAT
     *  Retrieve Operational Descriptor Information (CEEDOD)                                 RADDAT
     D CEEDOD...                                                                              RADDAT
     D                 PR                                                                     RADDAT
     D                                            extproc('CEEDOD')                           RADDAT
     D  i_posn                       10I 0 const                                              RADDAT
     D  o_desctype                   10I 0                                                    RADDAT
     D  o_datatype                   10I 0                                                    RADDAT
     D  o_descinf1                   10I 0                                                    RADDAT
     D  o_descinf2                   10I 0                                                    RADDAT
     D  o_datalen                    10I 0                                                    RADDAT
     D  o_fc                         12A          options(*omit   )                           RADDAT
     *                                                                                       RADDAT
     *  Reference fields for CEEDOD API                                                      RADDAT
     D descInf_t       DS                  based(pDummy)   qualified                          RADDAT
     D  desctype                     10I 0                                                    RADDAT
     D  datatype                     10I 0                                                    RADDAT
     D  descinf1                     10I 0                                                    RADDAT
     D  descinf2                     10I 0                                                    RADDAT
     D  datalen                      10I 0                                                    RADDAT
     *                                                                                       RADDAT
     *  Test for Omitted Argument (CEETSTA) API                                              RADDAT
     D CEETSTA...                                                                             RADDAT
     D                 PR                                                                     RADDAT
     D                                            extproc('CEETSTA')                          RADDAT
     D  io_isPresent                 10I 0                                                    RADDAT
     D  i_argNum                     10I 0 const                                              RADDAT
     D  o_fc                         12A          options(*omit   )                           RADDAT
     *                                                                                       RADDAT
     *  Get String Information (CEEGSI) API                                                  RADDAT
     D CEEGSI...                                                                              RADDAT
     D                 PR                                                                     RADDAT
     D                                            extproc('CEEGSI')                           RADDAT
     D  i_posn                       10I 0 const                                              RADDAT
     D  o_datatype                   10I 0                                                    RADDAT
     D  o_curlen                     10I 0                                                    RADDAT
     D  o_maxlen                     10I 0                                                    RADDAT
     D  o_fb                         12A          options(*omit   )                           RADDAT
     *                                                                                       RADDAT
     *  Reference fields for CEEGSI API                                                      RADDAT
     D strInf_t        DS                  based(pDummy)   qualified                          RADDAT
     D  datatype                     10I 0                                                    RADDAT
     D  curlen                       10I 0                                                    RADDAT
     D  maxlen                       10I 0                                                    RADDAT
     *                                                                                       RADDAT
     * ---------------------------------------------------------------                       RADDAT
     *   Math APIs                                                                           RADDAT
     * ---------------------------------------------------------------                       RADDAT
     *                                                                                       RADDAT
     *  Logarithm base 10 (double float)                                                     RADDAT
     D CEESDLG1...                                                                            RADDAT
     D                 PR                  extproc('CEESDLG1')                                RADDAT
     D  i_value                       8F   const                                              RADDAT
     D  o_result                      8F                                                      RADDAT
     *                                                                                       RADDAT
     * ---------------------------------------------------------------                       RADDAT
     *   ILE CEE Date and Time APIs                                                          RADDAT
     * ---------------------------------------------------------------                       RADDAT
     *                                                                                       RADDAT
     *  Convert Lilian Date to Character Format (CEEDATE) API                                RADDAT
     D CEEDATE         PR                  opdesc extproc('CEEDATE')                          RADDAT
     D   lilian_date                 10I 0 const                                              RADDAT
     D   date_format                 80A   const options(*varsize)                            RADDAT
     D   char_date                   80A   options(*varsize)                                  RADDAT
     D   feedback                    12A   options(*omit)                                     RADDAT
     *                                                                                       RADDAT
     *  Convert Date to Lilian Format (CEEDAYS) API                                          RADDAT
     D CEEDAYS         PR                  opdesc extproc('CEEDAYS')                          RADDAT
     D   char_date                   80A   const options(*varsize)                            RADDAT
     D   date_format                 80A   const options(*varsize)                            RADDAT
     D   lilian_date                 10I 0                                                    RADDAT
     D   feedback                    12A   options(*omit)                                     RADDAT
     *                                                                                       RADDAT
     * ---------------------------------------------------------------                       RADDAT
     *   Activation Group and Control Flow APIs                                              RADDAT
     * ---------------------------------------------------------------                       RADDAT
     *                                                                                       RADDAT
     *  Register Activation Group Exit Procedure (CEE4RAGE) API                              RADDAT
     D CEE4RAGE...                                                                            RADDAT
     D                 PR                  extproc('CEE4RAGE')                                RADDAT
     D  i_pProc                        *   const procptr                                      RADDAT
     D   fc                          12A         options(*OMIT)                               RADDAT
     *                                                                                       RADDAT
     D END_ACTGRP_CODE_EXCEPTION_MESSAGE...                                                   RADDAT
     D                 C                   x'40000000'                                        RADDAT
     D END_ACTGRP_CODE_ABNORMAL_END...                                                        RADDAT
     D                 C                   x'00008000'                                        RADDAT
     D END_ACTGRP_CODE_ACTGRP_IS_ENDING...                                                    RADDAT
     D                 C                   x'00004000'                                        RADDAT
     D END_ACTGRP_CODE_INIT_BY_RCLACTGRP...                                                   RADDAT
     D                 C                   x'00002000'                                        RADDAT
     D END_ACTGRP_CODE_INIT_BY_JOB_END...                                                     RADDAT
     D                 C                   x'00001000'                                        RADDAT
     D END_ACTGRP_CODE_INIT_BY_EXIT_VERB...                                                   RADDAT
     D                 C                   x'00000800'                                        RADDAT
     D END_ACTGRP_CODE_INIT_BY_FUNCTION_CHECK...                                              RADDAT
     D                 C                   x'00000400'                                        RADDAT
     D END_ACTGRP_CODE_INIT_BY_OUT_OF_SCOPE_JUMP...                                           RADDAT
     D                 C                   x'00000200'                                        RADDAT
     *                                                                                       RADDAT
     *  Register Call Stack Entry Termination User Exit Procedure (CEERTX)                   RADDAT
     D CEERTX...                                                                              RADDAT
     D                 PR                         extproc('CEERTX')                           RADDAT
     D  i_procPtr                      *   const  procptr                                     RADDAT
     D  i_rtxToken                     *   const  options(*omit)                              RADDAT
     D  o_fc                         12A          options(*omit)                              RADDAT
     *                                                                                       RADDAT
     D CEERTX_user_exit...                                                                    RADDAT
     D                 PR                         extproc('CEERTX_user_exit')                 RADDAT
     D  i_rtxToken                     *   const                                              RADDAT
     *
     *  Unregister Call Stack Entry Termination User Exit Procedure (CEEUTX)
     D CEEUTX...
     D                 PR                         extproc('CEEUTX')
     D  i_procPtr                      *   const  procptr
     D  o_fc                         12A          options(*omit)
     *                                                                                       RADDAT
 DEF  /ENDIF                                                                                  RADDAT
