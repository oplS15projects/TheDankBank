#lang racket

(require "Ciphers.rkt")

; Definition for nil because fuck you
(define nil '())

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
        (if (equal? ((car acc) 'get-password) password)
            (car acc)
            (error "Invalid Password"))
        (error "No account with that username exists"))))

; Called from Create-Account button.
; Calls make-account and adds the return
; procedure to database
(define (create-account username password)
  ; Predicate to pass to filter
  (define (equal-username? acc)
    (equal? (acc 'get-username) username))
  (if (equal? (filter equal-username? database) nil)
      (set! database (append database (list (make-account username password 0))))
      (error "An account with that name already exists")))

; Constructor for the object
(define (make-account username password balance)
  ; Methods
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        (error "Insufficient funds")))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  ; Accessor to member methods
  (define (dispatch m)
    (cond ((eq? m 'get-username) username)
          ((eq? m 'get-password) password)
          ((eq? m 'get-balance) balance)
          ((eq? m 'withdraw) withdraw)
          ((eq? m 'deposit) deposit)
          (else (error "Unknown request -- MAKE-ACCOUNT"
                       m))))
    dispatch)

(set! database (append database (list (make-account "fredm" "ilovescheme" 99999))))

(provide (all-defined-out))