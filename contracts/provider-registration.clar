;; Provider Registration Contract
;; Records details of available medical services

(define-data-var last-id uint u0)

(define-map providers
  { id: uint }
  {
    name: (string-ascii 100),
    specialty: (string-ascii 50),
    location: (string-ascii 100),
    contact: (string-ascii 100),
    available: bool,
    owner: principal
  }
)

;; Register provider
(define-public (register
    (name (string-ascii 100))
    (specialty (string-ascii 50))
    (location (string-ascii 100))
    (contact (string-ascii 100))
  )
  (let
    (
      (new-id (+ (var-get last-id) u1))
    )
    (var-set last-id new-id)

    (map-set providers
      { id: new-id }
      {
        name: name,
        specialty: specialty,
        location: location,
        contact: contact,
        available: true,
        owner: tx-sender
      }
    )

    (ok new-id)
  )
)

;; Update availability
(define-public (update-availability
    (provider-id uint)
    (available bool)
  )
  (let
    (
      (provider (unwrap! (map-get? providers { id: provider-id }) (err u404)))
    )
    (asserts! (is-eq tx-sender (get owner provider)) (err u403))

    (map-set providers
      { id: provider-id }
      (merge provider { available: available })
    )

    (ok true)
  )
)

;; Get provider
(define-read-only (get-provider (id uint))
  (map-get? providers { id: id })
)
