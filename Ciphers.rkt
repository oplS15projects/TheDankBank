#lang racket

; So I can type less
(define (ord char)
  (char->integer char))

(define (chr num)
  (integer->char num))

; Methods for the Vigenere Cipher
(define (cycle in len)
  (define lst (cond ((list? in) in)
                    ((string? in) (string->list in))
                    ((symbol? in) (string->list (symbol->string in)))))
  (define (cyc dst src)
    (cond ((= len (length dst)) dst) 
          ((null? src) (cyc dst lst))
          (else (cyc (cons (car src) dst) (cdr src)))))
  (reverse (cyc null lst)))

(define (gen-v-key password-len key)
  (map (lambda (x) (if (> x 96) 
                       (- x 96)
                       (- x 64)))
       (map ord (cycle key password-len))))

;;; shift
;;; Parameters: Integer num: number to be shifted. should be the ascii value of a letter character.
;;;             Integer k: the shift value (Between 0 and 26 inclusive)
;;;             Symbol ('encrypt or 'decrypt)

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
  

(define (vigenere-cipher password keyword method)
  (define (folder-proc a b result)
    (cons (shift a b method) result))
  (define keylist (gen-v-key (string-length password) keyword))
  (list->string (map chr (foldr folder-proc '() (map ord (string->list password)) keylist))))
  
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
(provide vigenere-cipher)
