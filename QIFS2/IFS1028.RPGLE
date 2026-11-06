**FREE
//---------------------------------------------------------------
// Datenstruktur für Message-ID : IFS1028
//
// Fehler bei der Ermittlung der eindeutigen ID der Datei '&1'
//
DCL-DS IFS1028;
  IFS10281 CHAR(256) INZ(*BLANKS);
  IFS10282 PACKED(010) INZ(*ZEROS);
  IFS10283 CHAR(128) INZ(*BLANKS);
END-DS;
DCL-S IFS1028_SIZE BINDEC(8) INZ(0390);
//
