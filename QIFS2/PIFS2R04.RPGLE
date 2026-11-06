**FREE
/IF NOT DEFINED(PIFS2R04)
/DEFINE PIFS2R04
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
//  Creates an application message.
DCL-PR AppMsg_new LIKEDS(msg_t) EXTPROC('IFS2R04_AppMsg_new');
  i_ID   CONST LIKE(msg_t.ID);
  i_data CONST LIKE(msg_t.data) OPTIONS(*NOPASS);
  i_type CONST LIKE(msg_t.data) OPTIONS(*NOPASS);
END-PR;
//
//  Creates an application ESCAPE message.
DCL-PR AppMsg_newEscape LIKEDS(msg_t) EXTPROC('IFS2R04_AppMsg_newEscape');
  i_ID   CONST LIKE(msg_t.ID);
  i_data CONST LIKE(msg_t.data) OPTIONS(*NOPASS);
END-PR;
//
/ENDIF
