#lang racket

(require "Ciphers.rkt"
         "BankAccountClass.rkt"
         racket/gui)

(define window (new frame% [label "The Dank Bank (Dank Memes since 1993)"]
                           [width  600]
                           [height 200]))

; local variable for active account
(define active-account nil)

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
                                              (begin (set! active-account (login-account (send username-text get-value)
                                                                                         (send password-text get-value)))
                                                     (send login-panel enable #f)
                                                     (send button-panel enable #f)
                                                     (send balance-panel enable #t)
                                                     (update-balance)))]))
(define clear-button (new button% [label "Clear"]
                                  [parent button-panel]
                                  [callback (lambda (b e)
                                              (begin (send username-text set-value "")
                                                     (send password-text set-value "")))]))
(define create-button (new button% [label "Create Account"]
                                   [parent button-panel]
                                   [callback (lambda (b e)
                                               (create-account (send username-text get-value)
                                                               (send password-text get-value)))]))

#|Output|#
(define output-panel (new vertical-panel% [parent window]
                                          [alignment '(center top)]))

(define balance-message (new message% [label "Balance"]
                                      [parent output-panel]))
(define (update-balance)
  (send balance-message set-label (string-append "λ " (number->string (active-account 'get-balance)))))


(define balance-panel (new horizontal-panel% [parent output-panel]
                                             [alignment '(center top)]
                                             [enabled #f]))
(define amount-text (new text-field% [label "Amount:"]
                                     [parent balance-panel]))
(define withdraw-button (new button% [label "Withdraw"]
                                     [parent balance-panel]
                                     [callback (lambda (b e)
                                                 (begin (withdraw-account active-account (send amount-text get-value))
                                                        (update-balance)))]))
(define deposit-button (new button% [label "Deposit"]
                                    [parent balance-panel]
                                    [callback (lambda (b e)
                                                (begin (deposit-account active-account (send amount-text get-value))
                                                       (update-balance)))]))
(define logout-button (new button% [label "Logout"]
                                   [parent balance-panel]
                                   [callback (lambda (b e)
                                               (begin (send balance-panel enable #f)
                                                      (send balance-message set-label "Balance")
                                                      (send login-panel enable #t)
                                                      (send button-panel enable #t)
                                                      (send amount-text set-value "")
                                                      (set! active-account nil)))]))

#|SHOW WINDOW|#
(send window show #t)