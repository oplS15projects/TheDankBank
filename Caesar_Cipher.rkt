#lang racket

(define (ord char)
  (char->integer char))

(define (chr num)
  (integer->char num))

;;; shift
;;; Parameters: Integer num: number to be shifted. should be the ascii value of a letter character.
;;;             Integer k: the shift value (Between 0 and 26 inclusive)
;;;             Symbol ('encrypt or 'decrypt)

(define (shift num k method)
  (define (transform upper-bound combiner combiner-inverse)
    (if (> (combiner num k) upper-bound)
        (combiner-inverse (combiner num k) 26)
        (combiner num k)))
  (define (transform-encrypt upper-bound)
    (transform upper-bound + -))
  (define (transform-decrypt upper-bound)
    (transform upper-bound - +))
  ;; assert 0 <= k <= 26
  (if (and (<= k 26) (>= k 0))
      ;; encryption cases
      (cond ((eq? method 'encrypt)
             ;; case for uppercase ascii letters
             (cond ((and (>= num 65) (<= num 90))
                    (transform-encrypt 90))
                   ;;case for lowercase ascii letters
                   ((and (>= num 97) (<= num 122))
                    (transform-encrypt 122))
                   (else num)))
            ;; decryption cases
            ((eq? method 'decrypt)
             ;; case for uppercase ascii letters
             (cond ((and (>= num 65) (<= num 90))
                    (transform-decrypt 65))
                   ;;case for lowercase ascii letters
                   ((and (>= num 97) (<= num 122))
                    (transform-decrypt 97))
                   (else num)))
            (else (error "Unknown Method: Try 'encrypt or 'decrypt")))
      (error "Value of K is not between 0 and 26 (inclusive)")))
  
  
;;; Caesar-Cipher
;;; Parameters: String
;;;             Integer (Between 0 and 26 inclusive)
;;;             Symbol ('encrypt or 'decrypt)

(define (caesar-cipher password k method)
  (list->string
   (map chr 
        (map (lambda(ascii) (shift ascii k method))
             (map ord (string->list password))))))

(provide caesar-cipher)
