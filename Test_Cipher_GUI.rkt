#lang racket

(require "Ciphers.rkt"
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

(define (decrypt?) (if (send e-or-d-checkbox get-value) 'decrypt 'encrypt))

#|Caesar Cipher|#
(define panel-caesar (new horizontal-panel% [parent window]))

(define text-caesar (new text-field% [label "Caesar Shift Value:"]
                                     [parent panel-caesar]
                                     [min-width 2]
                                     [stretchable-width #f]))

(define button-caesar (new button% [label "Use Caesar Cipher!"]
                                   [parent panel-caesar]
                                   [callback (lambda (b e) (send message
                                                                 set-label
                                                                 (caesar-cipher (send text get-value)
                                                                                (string->number (send text-caesar get-value))
                                                                                (decrypt?))))]))

#|Vigenere Cipher|#

#|Output|#
(new message% [label "===OUTPUT==="] [parent window])
(define message (new message% [label "Output Here"]
                              [parent window]
                              [auto-resize #t]))


#|SHOW WINDOW|#
(send window show #t)
