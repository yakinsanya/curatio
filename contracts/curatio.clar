;; Title: Curatio - The On-Chain Knowledge Discovery Protocol
;;
;; Summary:
;;   Curatio is a Bitcoin-anchored protocol on Stacks that transforms
;;   community participation into a transparent knowledge marketplace.
;;   It enables decentralized submission, validation, and rewarding
;;   of high-quality content across multiple domains.
;;
;; Description:
;;   Curatio introduces a merit-driven ecosystem for discovering and
;;   curating internet knowledge:
;;     - Participants contribute content links with categorized topics
;;     - The community collectively appraises submissions via voting
;;     - Contributors of impactful content earn reputation and rewards
;;     - Low-quality or misleading content can be flagged for review
;;     - All activity is immutably recorded on the Stacks blockchain
;;
;;   The protocol emphasizes:
;;     - Incentive alignment (stake, reputation, STX gratuities)
;;     - Transparent governance with administrator oversight
;;     - A flexible category system for evolving domains of knowledge
;;
;;   By combining reputation signals with financial incentives,
;;   Curatio builds a trusted, censorship-resistant content curation
;;   layer for the open web.
;;

;; Core Constants & Error Codes

(define-constant PROTOCOL_ADMINISTRATOR tx-sender)

;; Error Codes
(define-constant ERR_UNAUTHORIZED_ACCESS (err u100))
(define-constant ERR_INVALID_SUBMISSION (err u101))
(define-constant ERR_DUPLICATE_ENTRY (err u102))
(define-constant ERR_NONEXISTENT_ITEM (err u103))
(define-constant ERR_INADEQUATE_BALANCE (err u104))
(define-constant ERR_INVALID_TOPIC (err u105))
(define-constant ERR_INVALID_FLAG (err u106))
(define-constant ERR_OVERFLOW (err u107))
(define-constant ERR_INVALID_APPRAISAL (err u108))
(define-constant ERR_INVALID_ITEM_ID (err u109))

;; Protocol Parameters
(define-constant MIN_HYPERLINK_LENGTH u10)
(define-constant MAX_UINT u340282366920938463463374607431768211455)

;; State Variables
(define-data-var submission-charge uint u10)
(define-data-var aggregate-submissions uint u0)
(define-data-var content-topics (list 10 (string-ascii 20)) (list "Technology" "Science" "Art" "Politics" "Sports"))

;; Data Storage Maps
(define-map curated-items
  { item-identifier: uint }
  {
    originator: principal,
    headline: (string-ascii 100),
    hyperlink: (string-ascii 200),
    topic: (string-ascii 20),
    publication-epoch: uint,
    appraisals: int,
    gratuities: uint,
    flags: uint,
  }
)

(define-map participant-appraisals
  {
    participant: principal,
    item-identifier: uint,
  }
  { appraisal: int }
)

(define-map participant-credibility
  { participant: principal }
  { metric: int }
)

;; Private Helper Functions

;; Check if an item exists
(define-private (item-exists (item-identifier uint))
  (is-some (map-get? curated-items { item-identifier: item-identifier }))
)

;; Filter valid items for retrieval
(define-private (not-none (item (optional {
  originator: principal,
  headline: (string-ascii 100),
  hyperlink: (string-ascii 200),
  topic: (string-ascii 20),
  publication-epoch: uint,
  appraisals: int,
  gratuities: uint,
  flags: uint,
})))
  (is-some item)
)