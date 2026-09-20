     H DEBUG
     H OPTION(*SRCSTMT : *NODEBUGIO)
      /IF NOT DEFINED(NO_DECEDIT)                                                             RADDAT
     H DECEDIT('0,')                                                                          RADDAT
      /ENDIF                                                                                  RADDAT
     H DATEDIT(*DMY.)                                                                         RADDAT
     H DATFMT(*ISO ) TIMFMT(*ISO )                                                            RADDAT
     H EXPROPTS(*RESDECPOS)
     H EXTBININT(*YES)
     H CCSID(*CHAR: *JOBRUN)                                                                  RADDAT
