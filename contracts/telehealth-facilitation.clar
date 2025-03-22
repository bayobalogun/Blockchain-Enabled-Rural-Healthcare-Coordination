;; Telehealth Facilitation Contract
;; Manages remote consultations when possible

(define-data-var last-id uint u0)

(define-map sessions
  { id: uint }
  {
    provider-id: uint,
    patient: principal,
    scheduled-time: uint,
    duration: uint,
    session-link: (string-ascii 100),
    status: (string-ascii 20)
  }
)

;; Schedule session
(define-public (schedule-session
    (provider-id uint)
    (scheduled-time uint)
    (duration uint)
  )
  (let
    (
      (new-id (+ (var-get last-id) u1))
    )
    (var-set last-id new-id)

    (map-set sessions
      { id: new-id }
      {
        provider-id: provider-id,
        patient: tx-sender,
        scheduled-time: scheduled-time,
        duration: duration,
        session-link: "",
        status: "scheduled"
      }
    )

    (ok new-id)
  )
)

;; Set session link
(define-public (set-session-link
    (session-id uint)
    (session-link (string-ascii 100))
  )
  (let
    (
      (session (unwrap! (map-get? sessions { id: session-id }) (err u404)))
    )

    (map-set sessions
      { id: session-id }
      (merge session {
        session-link: session-link,
        status: "ready"
      })
    )

    (ok true)
  )
)

;; Complete session
(define-public (complete-session
    (session-id uint)
  )
  (let
    (
      (session (unwrap! (map-get? sessions { id: session-id }) (err u404)))
    )

    (map-set sessions
      { id: session-id }
      (merge session { status: "completed" })
    )

    (ok true)
  )
)

;; Get session
(define-read-only (get-session (id uint))
  (map-get? sessions { id: id })
)
