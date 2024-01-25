import React, { useState } from 'react'
import useSWR from 'swr'
import BellButton from './BellButton'
import Notifications from './Notifications'
import fetcher from '../../fetcher'

export function useNotification(status) {
  const baseUrl = '/api/notifications.json'
  const apiKey = status ? `${baseUrl}?status=${status}` : baseUrl
  const { data, error } = useSWR(apiKey, fetcher)
  return { notifications: data?.notifications, error }
}

export default function NotificationsBell() {
  const [showNotifications, setShowNotifications] = useState(false)

  const { notifications, error } = useNotification('unread')

  const notificationExist = notifications?.length > 0
  const hasCountClass = notificationExist ? 'has-count' : 'has-no-count'

  const clickOutsideNotifications = (e) => {
    if (e.target !== e.currentTarget) return

    setShowNotifications(false)
  }

  const openUnconfirmedItems = () => {
    const links = document.querySelectorAll(
      '.header-dropdown__item-link.unconfirmed_link'
    )
    links.forEach((link) => {
      window.open(link.href, '_target', 'noopener')
    })
  }

  if (error) {
    console.warn(error)
    return <div>failed to load</div>
  }

  return (
    <div className={hasCountClass}>
      <BellButton setShowNotifications={setShowNotifications} />
      {notifications && showNotifications && (
        <div>
          <label
            className="header-dropdown__background"
            onClick={clickOutsideNotifications}></label>
          <div className="header-dropdown__inner is-notification">
            <Notifications notifications={notifications} />
            <footer className="header-dropdown__footer">
              <a
                href="/notifications?status=unread"
                className="header-dropdown__footer-link">
                全ての未読通知
              </a>
              <a href="/notifications" className="header-dropdown__footer-link">
                全ての通知
              </a>
              <a
                href="/notifications/allmarks"
                className="header-dropdown__footer-link"
                data-method="post">
                全て既読にする
              </a>
              <button
                className="header-dropdown__footer-link"
                onClick={openUnconfirmedItems}>
                全て別タブで開く
              </button>
            </footer>
          </div>
        </div>
      )}
    </div>
  )
}
