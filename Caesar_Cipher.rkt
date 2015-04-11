#lang racket

(define (ord char)
  (char->integer char))

(define (chr num)
  (integer->char num))

(define (shift num k method)
  (if (and (<= k 26) (>= k 0))
      (cond ((eq? method 'encrypt)
             (cond ((and (>= num 65) (<= num 90))
                    (if (> (+ num k) 90)
                        (- (+ num k) 26)
                        (+ num k)))
                   ((and (>= num 97) (<= num 122))
                    (if (> (+ num k) 122)
                        (- (+ num k) 26)
                        (+ num k)))
                   (else num)))
            ((eq? method 'decrypt)
             (cond ((and (>= num 65) (<= num 90))
                    (if (< (- num k) 65)
                        (+ (- num k) 26)
                        (- num k)))
                   ((and (>= num 97) (<= num 122))
                    (if (< (- num k) 97)
                        (+ (- num k) 26)
                        (- num k)))
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
