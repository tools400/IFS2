**FREE
//---------------------------------------------------------------
// Datenstruktur für Message-ID : IFS1021
//
// Fehler beim Ermitteln der Erstellungszeit der Datei '&1' au
//
DCL-DS IFS1021;
  IFS10211 CHAR(256) INZ(*BLANKS);
  IFS10212 PACKED(010) INZ(*ZEROS);
  IFS10213 CHAR(128) INZ(*BLANKS);
END-DS;
DCL-S IFS1021_SIZE BINDEC(8) INZ(0390);
//
