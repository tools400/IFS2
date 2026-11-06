**FREE
//---------------------------------------------------------------
// Datenstruktur für Message-ID : IFS1009
//
// Fehler beim Umbenennen der Datei '&1' in '&2' aufgetreten.
//
DCL-DS IFS1009;
  IFS10091 CHAR(180) INZ(*BLANKS);
  IFS10092 CHAR(180) INZ(*BLANKS);
  IFS10093 PACKED(010) INZ(*ZEROS);
  IFS10094 CHAR(128) INZ(*BLANKS);
END-DS;
DCL-S IFS1009_SIZE BINDEC(8) INZ(0494);
//
