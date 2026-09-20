      *---------------------------------------------------------------
      * Datenstruktur für Message-ID : IFS1000
      *
      * Fehler beim Öffnen der Datei '&1' aufgetreten.
      *
     D IFS1000         DS
     D  IFS10001                    256A   INZ(*BLANKS)
     D  IFS10002                    010P 0 INZ(*ZEROS )
     D  IFS10003                    128A   INZ(*BLANKS)
     D IFS1000_SIZE    S              8B 0 INZ(0390)
      *
