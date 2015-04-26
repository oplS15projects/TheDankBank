#lang racket

(require "Ciphers.rkt"
         racket/gui
         db)

; Definition for nil because fuck you
(define nil '())

;GUI Error printing
(define (gui-error err-string)
  (let* ((err-window  (new frame%   [label "Error"]))
         (err-message (new message% [label err-string]
                                    [parent err-window]))
         (err-button  (new button%  [label "OK"]
                                    [parent err-window]
                                    [callback (lambda (b e) (send err-window show #f))])))
    (begin (send err-window show #t)
           (error err-string))))

(define (gui-error-overflow)
  (let* ((err-window  (new frame%   [label "Error"]))
         (err-message (new message% [label "You dropped your lambdas!"]
                                    [parent err-window]))
         (err-bitmap  (new message% [label (read-bitmap "ilovescheme.bmp")]
                                    [parent err-window]))
         (err-button  (new button%  [label "OK"]
                                    [parent err-window]
                                    [callback (lambda (b e) (send err-window show #f))])))
    (send err-window show #t)))

; Database of all of the bank accounts
(define database nil)

; Called from Deposit button
(define (deposit-account account amount)
  ((account 'deposit) (string->number amount))) 

(define (withdraw-account account amount)
  ((account 'withdraw) (string->number amount)))

; Called from Login button
; Returns the account if the username and password match
; Prints an error otherwise.
(define (login-account username password)
  (let ((acc (filter (lambda(x) (equal? (x 'get-username) username)) database)))
    (if (not (equal? acc nil))
        (if (equal? ((car acc) 'get-password) (vigenere-cipher password "dankmemes" 'encrypt))
            (car acc)
            (gui-error "Invalid Password"))
        (gui-error "No account with that username exists"))))

; Called from Create-Account button.
; Calls make-account and adds the return
; procedure to database
(define (create-account username password)
  ; Predicate to pass to filter
  (let* ((pass (vigenere-cipher password "dankmemes" 'encrypt))
         (new-account (make-account username pass 0)))
    (define (equal-username? acc)
      (equal? (acc 'get-username) username))
    (if (equal? (filter equal-username? database) nil)
        (begin (set! database (append database (list new-account)))
               (insert-to-db new-account))
        (gui-error "An account with that name already exists"))))

; Constructor for the object
(define (make-account username password balance)
  ; Methods
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        (gui-error "Insufficient funds")))
  (define (deposit amount)
    (if (> (+ balance amount) 99999)
        (begin
          (set! balance 0)
          (gui-error-overflow))
        (set! balance (+ balance amount)))
    balance)
  ; Accessor to member methods
  (define (dispatch m)
    (cond ((eq? m 'get-username) username)
          ((eq? m 'get-password) password)
          ((eq? m 'get-balance) balance)
          ((eq? m 'withdraw) withdraw)
          ((eq? m 'deposit) deposit)
          (else (error "Unknown request -- MAKE-ACCOUNT" m))))
    dispatch)

; Database scheme
(define dbc (sqlite3-connect #:database "bank.db" #:mode 'create))
(query-exec dbc "CREATE TABLE IF NOT EXISTS accounts(login TEXT PRIMARY KEY, password TEXT, amount INTEGER)")

(define (insert-to-db account)
  (let ((username (account 'get-username))
        (password (account 'get-password))
        (balance  (account 'get-balance)))
    (query-exec dbc 
                "REPLACE INTO accounts(login, password, amount) VALUES ($1, $2, $3)"
                username 
                password 
                balance)))

(define (load-from-db)
  (let ((get-username (lambda (row) (vector-ref row 0)))
        (get-password (lambda (row) (vector-ref row 1)))
        (get-amount   (lambda (row) (vector-ref row 2))))
    (for ([i (query-rows dbc "SELECT * FROM accounts")])
      (set! database (append database (list (make-account (get-username i)
                                                          (get-password i)
                                                          (get-amount   i))))))))
(load-from-db)

(provide (all-defined-out))
