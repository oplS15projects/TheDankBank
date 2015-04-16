#lang racket

(require "Ciphers.rkt"
         racket/gui)

(define window (new frame% [label "The Dank Bank (Dank Memes since 1993)"]
                           [width  600]
                           [height 200]))

#|Login and Password|#
(define login-panel (new vertical-panel% [parent window]
                                         [alignment '(center top)]))

(define username-text (new text-field% [label "Login:"]
                                       [parent login-panel]
                                       [horiz-margin 20]
                                       [stretchable-width #t]))
(define password-text (new text-field% [label "Password:"]
                                       [parent login-panel]
                                       [horiz-margin 20]
                                       [stretchable-width #t]))

#|Button Use|#
(define button-panel (new horizontal-panel% [parent window]
                                            [alignment '(center top)]))

(define login-button (new button% [label "Login"]
                                  [parent button-panel]
                                  [callback (lambda (b e)
                                              #|TODO: Login|# null)]))
(define clear-button (new button% [label "Clear"]
                                  [parent button-panel]
                                  [callback (lambda (b e)
                                              (begin (send username-text set-value "")
                                                     (send password-text set-value "")))]))
(define create-button (new button% [label "Create Account"]
                                   [parent button-panel]
                                   [callback (lambda (b e)
                                               #|TODO: Account making process|# null)]))

#|Output|#
(define output-panel (new vertical-panel% [parent window]
                                          [alignment '(center top)]))

(define balance-message (new message% [label "Balance"]
                                      [parent output-panel]))

#|SHOW WINDOW|#
(send window show #t)