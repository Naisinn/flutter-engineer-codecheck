# appium_test.py

from appium import webdriver
from appium.options.common import AppiumOptions
from appium.webdriver.common.appiumby import AppiumBy

# For W3C actions
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.actions import interaction
from selenium.webdriver.common.actions.action_builder import ActionBuilder
from selenium.webdriver.common.actions.pointer_input import PointerInput

import time

def main():
    options = AppiumOptions()
    options.platform_name = "Android"
    options.platform_version = "15"  # 実際のバージョンに合わせて変更
    options.device_name = "emulator-5554"
    options.set_capability("appium:automationName", "flutter")
    options.app = "/Users/nanaki/AndroidStudioProjects/flutter-engineer-codecheck/build/app/outputs/flutter-apk/app-debug.apk"
    options.ensure_webviews_have_pages = True
    options.native_web_screenshot = True
    options.new_command_timeout = 3600
    options.connect_hardware_keyboard = True

    driver = webdriver.Remote("http://127.0.0.1:4723/wd/hub", options=options)

    # テストステップの追加
    try:
        # 1. 検索キーワード入力フィールドを特定して値を入力
        search_field = driver.find_element(AppiumBy.ACCESSIBILITY_ID, "SearchKeywordTextField")
        search_field.click()
        search_field.send_keys("flutter")

        # 2. 検索ボタンを特定してクリック
        search_button = driver.find_element(AppiumBy.ACCESSIBILITY_ID, "SearchButton")
        search_button.click()

        # 3. 検索結果が表示されるのを待つ
        # 適宜待機や要素の確認を行う
        time.sleep(5)  # デモ用に5秒待機。実際にはWebDriverWaitを使用することを推奨。

        # 4. 検索結果の確認
        # ここでは、例として検索結果リスト内の特定の要素を探します。
        # 実際のアプリに合わせて修正してください。
        # 例えば、リポジトリ名の TextView を探す場合:
        repositories = driver.find_elements(AppiumBy.ACCESSIBILITY_ID, "RepositoryNameTextView")  # Key を適宜設定
        assert len(repositories) > 0, "検索結果が表示されていません。"

        print("テスト成功: 検索結果が表示されました。")

    except AssertionError as ae:
        print(f"テスト失敗: {ae}")
    except Exception as e:
        print(f"テスト失敗: {e}")
    finally:
        driver.quit()

if __name__ == "__main__":
    main()
