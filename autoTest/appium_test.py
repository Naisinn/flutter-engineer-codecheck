# appium_test.py

from appium import webdriver
from appium.options.common import AppiumOptions  # 正しいインポートパス
# from appium.webdriver.common.appiumby import AppiumBy  # 不要になりました

from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

def main():
    # 1. Desired Capabilities を設定
    options = AppiumOptions()
    # W3C standard caps
    options.set_capability("platformName", "Android")

    # Appium-specific caps ("appium:..." の形式)
    options.set_capability("appium:automationName", "flutter")   # 小文字の "flutter" を指定
    options.set_capability("appium:deviceName", "emulator-5554")
    options.set_capability("appium:app", "/Users/nanaki/AndroidStudioProjects/flutter-engineer-codecheck/build/app/outputs/flutter-apk/app-debug.apk")
    options.set_capability("appium:ensureWebviewsHavePages", True)
    options.set_capability("appium:nativeWebScreenshot", True)
    options.set_capability("appium:newCommandTimeout", 3600)
    options.set_capability("appium:connectHardwareKeyboard", True)

    # 2. Remote WebDriver セッション開始
    driver = webdriver.Remote("http://127.0.0.1:4723/wd/hub", options=options)

    # 3. テストステップの追加
    try:
        # 1. 検索キーワード入力フィールドを特定して値を入力
        search_field = driver.find_element("valueKey", "SearchKeywordTextField")
        search_field.click()
        search_field.send_keys("flutter")

        # 2. 検索ボタンを特定してクリック
        search_button = driver.find_element("valueKey", "SearchButton")
        search_button.click()

        # 3. 検索結果が表示されるのを待つ (WebDriverWait を使用)
        wait = WebDriverWait(driver, 10)  # 最大10秒待機
        # 検索結果のリポジトリ名が表示されることを待つ
        repositories = wait.until(
            EC.presence_of_all_elements_located(("valueKey", "RepositoryNameTextView"))
        )

        # 4. 検索結果の確認
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
