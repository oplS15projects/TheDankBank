#lang racket

(require "Caesar_Cipher.rkt"
         racket/gui)

(define window (new frame% [label "Cipher Test"]
                           [width 600]
                           [height 200]))

#|Input|#
(define panel-alpha (new horizontal-panel% [parent window]))


(define text (new text-field% [label ""]
                              [parent panel-alpha]))

(define e-or-d-checkbox (new check-box% [label "Check to decrypt"]
                                        [parent panel-alpha]))

#|Caesar Cipher|#

#|Vigenere Cipher|#

#|Output|#
(new message% [label "===OUTPUT==="] [parent window])
(define message (new message% [label "Output Here"]
                              [parent window]
                              [auto-resize #t]))


#|SHOW WINDOW|#
(send window show #t)
