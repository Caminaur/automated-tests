import 'package:automated_tests/models/article_model.dart';
import 'package:automated_tests/provider/news_change_notifier.dart';
import 'package:automated_tests/services/news_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNewsService extends Mock implements NewsService {}

void main() {
  late NewsChangeNotifier sut;
  late MockNewsService mockNewsService;
  setUp(() {
    mockNewsService = MockNewsService();
    sut = NewsChangeNotifier(mockNewsService);
  });

  test(
    "Initial values are correct",
    () {
      expect(sut.isLoading, false);
      expect(sut.articles, []);
    },
  );

  group("getArticles", () {
    final articlesFromService = [
      Article(title: 'Test 1', content: "Test 1 content"),
      Article(title: 'Test 2', content: "Test 2 content"),
      Article(title: 'Test 3', content: "Test 3 content"),
    ];
    void arrangeNewsServiceReturns3Articles() {
      when(() => mockNewsService.getArticles()).thenAnswer(
        (_) async => articlesFromService,
      );
    }

    test(
      "gets articles using the NewsService",
      () async {
        // Arrange - Arreging the mocks
        arrangeNewsServiceReturns3Articles();
        // Act - We call the method
        await sut.getArticles();
        // Accert - We check for something
        verify(() => mockNewsService.getArticles()).called(1);
      },
    );

    test(
      "indicates loading of data, sets articles to the ones from the service,indicates that data is not being loaded anymore",
      () async {
        // Arrange
        arrangeNewsServiceReturns3Articles();
        // Act
        final future = sut.getArticles();
        expect(sut.isLoading, true);
        await future;
        // Assert
        expect(sut.articles, articlesFromService);
        expect(sut.isLoading, false);
      },
    );
  });
}
