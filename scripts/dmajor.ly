\version "2.18.2"

 \header {
       title = "Testing etudomatic generated d major score"
       composer = "etudomatic"
     }
\paper{
        ragged-bottom=##t
        bottom-margin=0\mm
        page-count=1
  }


\score {
  \relative c' {
    \time 4/4 \key d \major
    d8 fis a
    e g b
    fis a cis
    g b d
    a cis e
    b d fis
    cis e g
    d fis a
    d a fis
    cis' g e
    b' fis d
    a' e cis
    g' d b
    fis' cis a
    e' b g
    d' a fis
    d1
  }
  \layout {}
  \midi {}
}
