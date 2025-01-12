;; Cross-Planet Environmental Effects Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-invalid-parameters (err u101))
(define-constant err-not-authorized (err u102))

;; Data Variables
(define-data-var effect-counter uint u0)
(define-map cross-planet-effects uint {
    name: (string-ascii 100),
    source-planet-id: uint,
    target-planet-id: uint,
    effect-type: (string-ascii 50),
    magnitude: int,
    creator: principal
})

;; Public Functions
(define-public (create-cross-planet-effect (name (string-ascii 100)) (source-planet-id uint) (target-planet-id uint) (effect-type (string-ascii 50)) (magnitude int))
    (let
        (
            (effect-id (+ (var-get effect-counter) u1))
        )
        (asserts! (and
            (is-some (contract-call? .ecosystem-parameters get-planet source-planet-id))
            (is-some (contract-call? .ecosystem-parameters get-planet target-planet-id))
        ) err-invalid-parameters)
        (map-set cross-planet-effects effect-id {
            name: name,
            source-planet-id: source-planet-id,
            target-planet-id: target-planet-id,
            effect-type: effect-type,
            magnitude: magnitude,
            creator: tx-sender
        })
        (var-set effect-counter effect-id)
        (ok effect-id)
    )
)

(define-public (update-effect-magnitude (effect-id uint) (new-magnitude int))
    (let
        (
            (effect (unwrap! (map-get? cross-planet-effects effect-id) err-invalid-parameters))
        )
        (asserts! (is-eq tx-sender (get creator effect)) err-not-authorized)
        (map-set cross-planet-effects effect-id
            (merge effect {
                magnitude: new-magnitude
            })
        )
        (ok true)
    )
)

;; Read-only Functions
(define-read-only (get-cross-planet-effect (effect-id uint))
    (map-get? cross-planet-effects effect-id)
)

(define-read-only (get-effect-count)
    (var-get effect-counter)
)

