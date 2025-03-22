;; Transportation Coordination Contract
;; Arranges travel to medical appointments

(define-data-var last-id uint u0)

(define-map rides
  { id: uint }
  {
    patient: principal,
    pickup-location: (string-ascii 100),
    destination: (string-ascii 100),
    appointment-time: uint,
    driver: (optional principal),
    status: (string-ascii 20)
  }
)

;; Request ride
(define-public (request-ride
    (pickup-location (string-ascii 100))
    (destination (string-ascii 100))
    (appointment-time uint)
  )
  (let
    (
      (new-id (+ (var-get last-id) u1))
    )
    (var-set last-id new-id)

    (map-set rides
      { id: new-id }
      {
        patient: tx-sender,
        pickup-location: pickup-location,
        destination: destination,
        appointment-time: appointment-time,
        driver: none,
        status: "requested"
      }
    )

    (ok new-id)
  )
)

;; Accept ride
(define-public (accept-ride
    (ride-id uint)
  )
  (let
    (
      (ride (unwrap! (map-get? rides { id: ride-id }) (err u404)))
    )

    (map-set rides
      { id: ride-id }
      (merge ride {
        driver: (some tx-sender),
        status: "accepted"
      })
    )

    (ok true)
  )
)

;; Complete ride
(define-public (complete-ride
    (ride-id uint)
  )
  (let
    (
      (ride (unwrap! (map-get? rides { id: ride-id }) (err u404)))
    )
    (asserts! (is-eq (some tx-sender) (get driver ride)) (err u403))

    (map-set rides
      { id: ride-id }
      (merge ride { status: "completed" })
    )

    (ok true)
  )
)

;; Get ride
(define-read-only (get-ride (id uint))
  (map-get? rides { id: id })
)
