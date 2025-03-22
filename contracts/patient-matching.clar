;; Patient Matching Contract
;; Connects individuals with appropriate care

(define-data-var last-id uint u0)

(define-map care-requests
  { id: uint }
  {
    patient: principal,
    care-type: (string-ascii 50),
    urgency: (string-ascii 20),
    location: (string-ascii 100),
    provider-id: (optional uint),
    status: (string-ascii 20)
  }
)

;; Request care
(define-public (request-care
    (care-type (string-ascii 50))
    (urgency (string-ascii 20))
    (location (string-ascii 100))
  )
  (let
    (
      (new-id (+ (var-get last-id) u1))
    )
    (var-set last-id new-id)

    (map-set care-requests
      { id: new-id }
      {
        patient: tx-sender,
        care-type: care-type,
        urgency: urgency,
        location: location,
        provider-id: none,
        status: "pending"
      }
    )

    (ok new-id)
  )
)

;; Accept request
(define-public (accept-request
    (request-id uint)
    (provider-id uint)
  )
  (let
    (
      (request (unwrap! (map-get? care-requests { id: request-id }) (err u404)))
    )

    (map-set care-requests
      { id: request-id }
      (merge request {
        provider-id: (some provider-id),
        status: "matched"
      })
    )

    (ok true)
  )
)

;; Get care request
(define-read-only (get-request (id uint))
  (map-get? care-requests { id: id })
)
