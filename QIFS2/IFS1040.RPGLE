**FREE
//---------------------------------------------------------------
// Datenstruktur für Message-ID : IFS1040
//
// Fehler beim Kopieren der Datei '&1' nach '&2' aufgetreten.
//
DCL-DS IFS1040;
  IFS10401 CHAR(120) INZ(*BLANKS);
  IFS10402 CHAR(120) INZ(*BLANKS);
  IFS10403 CHAR(007) INZ(*BLANKS);
  IFS10404 CHAR(256) INZ(*BLANKS);
END-DS;
DCL-S IFS1040_SIZE BINDEC(8) INZ(0503);
//
