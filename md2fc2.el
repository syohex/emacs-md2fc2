;;; md2fc2.el --- Markdown to fc2 format -*- lexical-binding: t -*-

;; Copyright (C) 2016 by Syohei YOSHIDA

;; Author: Syohei YOSHIDA <syohex@gmail.com>
;; URL: https://github.com/syohex/emacs-md2fc2
;; Version: 0.01
;; Package-Requires: ((emacs "24.3"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Convert markdown text into fc2 HTML.

;;; Code:

(defgroup md2fc2 nil
  "Markdown to fc2 blog format"
  :group 'markdown)

(defcustom md2fc2-dmm-account ""
  "DMM account"
  :type 'string)

(defvar md2fc2--product-url nil)

(defun md2fc2--large-image (url)
  (when (string-match "ps\\.jpg" url)
    (replace-match "pl.jpg" nil nil url)))

(defun md2fc2--product-url (url)
  (save-match-data
    (with-temp-buffer
      (unless (zerop (process-file "curl" nil t nil "-s" url))
        (error "Can't download '%s'" url))
      (goto-char (point-min))
      (when (re-search-forward "<meta property=\"og:image\" content=\"\\([^\"]+\\)\"\\s-*/>" nil t)
        (let ((image (match-string-no-properties 1)))
          (format "<a href=\"%s\"><img src=\"%s\" /></a>"
                  md2fc2--product-url (md2fc2--large-image image)))))))

(defun md2fc2--product-image ()
  (goto-char (point-min))
  (when (re-search-forward "^@@\\s-*\\(\\S-+\\)$" nil t)
    (let ((url (match-string-no-properties 1)))
      (setq md2fc2--product-url
            (if (string-match-p "dmm\\.co\\.jp" url)
                (concat url md2fc2-dmm-account)
              url)))
    (let ((image-url (md2fc2--product-url (match-string-no-properties 1))))
      (replace-match image-url))))

(defun md2fc2--header1 ()
  (goto-char (point-min))
  (while (re-search-forward "^# \\(.+\\)$" nil t)
    (replace-match
     (format "<span style=\"font-size:x-large;\">%s</span>"
             (match-string-no-properties 1)))))

(defun md2fc2--header2 ()
  (goto-char (point-min))
  (while (re-search-forward "^## \\(.+\\)$" nil t)
    (replace-match
     (format "<span style=\"font-size:large;\">%s</span>"
             (match-string-no-properties 1)))))

(defun md2fc2--image ()
  (goto-char (point-min))
  (while (re-search-forward "^!\\[\\([^]]+\\)\\](\\([^)]+\\))" nil t)
    (replace-match
     (format "<a href=\"%s\" target=\"_blank\"><img src=\"%s\" alt=\"%s\" /></a>"
             md2fc2--product-url
             (match-string-no-properties 2)
             (match-string-no-properties 1)))))

(defun md2fc2--kill-old-buffer ()
  (let ((buf (get-buffer "*md2fc2*")))
    (when buf
      (kill-buffer buf))))

;;;###autoload
(defun md2fc2 ()
  (interactive)
  (let ((markdown (buffer-substring-no-properties
                   (point-min) (point-max))))
    (md2fc2--kill-old-buffer)
    (with-current-buffer (get-buffer-create "*md2fc2*")
      (read-only-mode -1)
      (erase-buffer)
      (insert markdown)
      (goto-char (point-min))
      (md2fc2--product-image)
      (md2fc2--header1)
      (md2fc2--header2)
      (md2fc2--image)
      (read-only-mode +1)
      (pop-to-buffer (current-buffer))
      (goto-char (point-min)))))

(provide 'md2fc2)

;;; md2fc2.el ends here
