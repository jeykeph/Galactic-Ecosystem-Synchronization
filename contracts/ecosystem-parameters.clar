;; Ecosystem Parameters Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-invalid-parameters (err u101))
(define-constant err-not-authorized (err u102))

;; Data Variables
(define-data-var planet-counter uint u0)
(define-map planets uint {
    name: (string-ascii 100),
    gravity: uint,
    temperature: int,
    atmosphere: (string-ascii 50),
    water-percentage: uint,
    creator: principal
})

(define-map ecosystem-parameters (tuple (planet-id uint) (param-name (string-ascii 50))) int)

;; Public Functions
(define-public (create-planet (name (string-ascii 100)) (gravity uint) (temperature int) (atmosphere (string-ascii 50)) (water-percentage uint))
    (let
        (
            (planet-id (+ (var-get planet-counter) u1))
        )
        (map-set planets planet-id {
            name: name,
            gravity: gravity,
            temperature: temperature,
            atmosphere: atmosphere,
            water-percentage: water-percentage,
            creator: tx-sender
        })
        (var-set planet-counter planet-id)
        (ok planet-id)
    )
)

(define-public (set-ecosystem-parameter (planet-id uint) (param-name (string-ascii 50)) (value int))
    (let
        (
            (planet (unwrap! (map-get? planets planet-id) err-invalid-parameters))
        )
        (asserts! (is-eq tx-sender (get creator planet)) err-not-authorized)
        (map-set ecosystem-parameters {planet-id: planet-id, param-name: param-name} value)
        (ok true)
    )
)

;; Read-only Functions
(define-read-only (get-planet (planet-id uint))
    (map-get? planets planet-id)
)

(define-read-only (get-ecosystem-parameter (planet-id uint) (param-name (string-ascii 50)))
    (map-get? ecosystem-parameters {planet-id: planet-id, param-name: param-name})
)

(define-read-only (get-planet-count)
    (var-get planet-counter)
)

