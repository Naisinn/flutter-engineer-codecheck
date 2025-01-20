import unittest
from appium import webdriver
from appium.options.android import UiAutomator2Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

class GitHubSearchAppTest(unittest.TestCase):
    def setUp(self):
        # 新しい Options クラスを使って Desired Capabilities を定義
        options = UiAutomator2Options()
        options.platform_name = "Android"
        options.platform_version = "15"
        options.device_name = "emulator-5554"
        options.automation_name = "UiAutomator2"
        options.app = "/Users/nanaki/AndroidStudioProjects/flutter-engineer-codecheck/build/app/outputs/flutter-apk/app-debug.apk"
        options.ensure_webviews_have_pages = True
        options.native_web_screenshot = True
        options.new_command_timeout = 3600

        # connectHardwareKeyboard 等のカスタム Capability は set_capability で設定
        options.set_capability("connectHardwareKeyboard", True)

        # webdriver.Remote で options=options を指定
        self.driver = webdriver.Remote("http://localhost:4723/wd/hub", options=options)
        self.wait = WebDriverWait(self.driver, 30)

    def tearDown(self):
        # 各テスト終了後にドライバを終了
        self.driver.quit()

    def test_normal_search(self):
        # 正常系検索テスト
        query_field = self.wait.until(EC.presence_of_element_located((By.ACCESSIBILITY_ID, 'queryTextField')))
        query_field.send_keys("flutter")

        owner_field = self.driver.find_element(By.ACCESSIBILITY_ID, 'ownerTextField')
        owner_field.send_keys("octocat")

        language_dropdown = self.driver.find_element(By.ACCESSIBILITY_ID, 'languageDropdown')
        language_dropdown.click()
        dart_option = self.wait.until(EC.presence_of_element_located((By.XPATH, "//*[@text='Dart']")))
        dart_option.click()

        search_button = self.driver.find_element(By.ACCESSIBILITY_ID, 'searchButton')
        search_button.click()

        results = self.wait.until(EC.presence_of_all_elements_located((By.XPATH, "//android.widget.ListView/*")))
        self.assertTrue(len(results) > 0, "検索結果が0件です。")

    def test_no_results_search(self):
        # 検索結果がゼロの場合のテスト
        query_field = self.wait.until(EC.presence_of_element_located((By.ACCESSIBILITY_ID, 'queryTextField')))
        query_field.send_keys("thisshouldyieldnoresults1234567890")

        owner_field = self.driver.find_element(By.ACCESSIBILITY_ID, 'ownerTextField')
        owner_field.clear()

        language_dropdown = self.driver.find_element(By.ACCESSIBILITY_ID, 'languageDropdown')
        language_dropdown.click()
        any_option = self.wait.until(EC.presence_of_element_located((By.XPATH, "//*[@text='Any']")))
        any_option.click()

        search_button = self.driver.find_element(By.ACCESSIBILITY_ID, 'searchButton')
        search_button.click()

        # 検索結果が存在しないことを確認
        self.wait.until(EC.presence_of_element_located((By.ACCESSIBILITY_ID, 'searchButton')))
        results = self.driver.find_elements(By.XPATH, "//android.widget.ListView/*")
        self.assertEqual(len(results), 0, "検索結果が存在します。")

    def test_empty_query(self):
        # 空のキーワードで検索した場合のテスト
        query_field = self.wait.until(EC.presence_of_element_located((By.ACCESSIBILITY_ID, 'queryTextField')))
        query_field.clear()

        search_button = self.driver.find_element(By.ACCESSIBILITY_ID, 'searchButton')
        search_button.click()

        # エラーメッセージが表示されることを検証
        error_message = self.wait.until(EC.presence_of_element_located((By.ACCESSIBILITY_ID, 'errorMessage')))
        self.assertIsNotNone(error_message, "エラーメッセージが表示されていません。")

    def test_ui_elements_presence(self):
        # UI コンポーネントの存在確認テスト
        self.assertIsNotNone(self.wait.until(EC.presence_of_element_located((By.ACCESSIBILITY_ID, 'queryTextField'))))
        self.assertIsNotNone(self.driver.find_element(By.ACCESSIBILITY_ID, 'ownerTextField'))
        self.assertIsNotNone(self.driver.find_element(By.ACCESSIBILITY_ID, 'languageDropdown'))
        self.assertIsNotNone(self.driver.find_element(By.ACCESSIBILITY_ID, 'searchButton'))


if __name__ == '__main__':
    unittest.main()