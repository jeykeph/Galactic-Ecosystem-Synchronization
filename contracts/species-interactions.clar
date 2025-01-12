;; Species Interactions Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-invalid-parameters (err u101))
(define-constant err-not-authorized (err u102))

;; Data Variables
(define-data-var species-counter uint u0)
(define-map species uint {
    name: (string-ascii 100),
    planet-id: uint,
    population: uint,
    diet: (string-ascii 50),
    creator: principal
})

(define-map interactions (tuple (species1-id uint) (species2-id uint)) {
    interaction-type: (string-ascii 50),
    strength: int
})

;; Public Functions
(define-public (create-species (name (string-ascii 100)) (planet-id uint) (population uint) (diet (string-ascii 50)))
    (let
        (
            (species-id (+ (var-get species-counter) u1))
        )
        (asserts! (is-some (contract-call? .ecosystem-parameters get-planet planet-id)) err-invalid-parameters)
        (map-set species species-id {
            name: name,
            planet-id: planet-id,
            population: population,
            diet: diet,
            creator: tx-sender
        })
        (var-set species-counter species-id)
        (ok species-id)
    )
)

(define-public (set-interaction (species1-id uint) (species2-id uint) (interaction-type (string-ascii 50)) (strength int))
    (let
        (
            (species1 (unwrap! (map-get? species species1-id) err-invalid-parameters))
            (species2 (unwrap! (map-get? species species2-id) err-invalid-parameters))
        )
        (asserts! (or (is-eq tx-sender (get creator species1)) (is-eq tx-sender (get creator species2))) err-not-authorized)
        (map-set interactions {species1-id: species1-id, species2-id: species2-id} {
            interaction-type: interaction-type,
            strength: strength
        })
        (ok true)
    )
)

;; Read-only Functions
(define-read-only (get-species (species-id uint))
    (map-get? species species-id)
)

(define-read-only (get-interaction (species1-id uint) (species2-id uint))
    (map-get? interactions {species1-id: species1-id, species2-id: species2-id})
)

(define-read-only (get-species-count)
    (var-get species-counter)
)

