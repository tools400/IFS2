**FREE
/IF NOT DEFINED(PIFS2R05)
/DEFINE PIFS2R05
//
// --------------------------------
//  Imported prototypes
// --------------------------------
/COPY QBASICS1,PBASICS1  Tools/400 Runtime Library
//
// --------------------------------
//  Exported procedures
// --------------------------------
//
//  Kills the IFS service program by sending a given ESCAPE message.
DCL-PR Application_killWithMsg EXTPROC('IFS2R05_Application_killWithMsg');
  i_msg VALUE LIKEDS(msg_t);
END-PR;
//
/ENDIF
