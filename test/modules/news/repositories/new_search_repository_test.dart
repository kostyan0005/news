import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:news/modules/news/repositories/news_search_repository.dart';

void main() {
  initializeDateFormatting('en');
  const rawXml = '''
    <rss version="2.0">
      <channel>
        <item>
        <title>Байден и Путин согласились на участие в саммите по вопросам безопасности - Украинская правда</title>
        <link>https://news.google.com/__i/rss/rd/articles/CBMiNmh0dHBzOi8vd3d3LnByYXZkYS5jb20udWEvcnVzL25ld3MvMjAyMi8wMi8yMS83MzI0NzM4L9IBAA?oc=5</link>
        <guid isPermaLink="false">1300278734</guid>
        <pubDate>Mon, 21 Feb 2022 01:59:09 GMT</pubDate>
        <description><ol><li><a href="https://news.google.com/__i/rss/rd/articles/CBMiNmh0dHBzOi8vd3d3LnByYXZkYS5jb20udWEvcnVzL25ld3MvMjAyMi8wMi8yMS83MzI0NzM4L9IBAA?oc=5" target="_blank">Байден и Путин согласились на участие в саммите по вопросам безопасности</a>&nbsp;&nbsp;<font color="#6f6f6f">Украинская правда</font></li><li><a href="https://news.google.com/__i/rss/rd/articles/CBMibGh0dHBzOi8va29ycmVzcG9uZGVudC5uZXQvd29ybGQvNDQ0OTM1MS1wdXR5bi15LWJhaWRlbi1wcnluaWFseS1wcmVkbG96aGVueWUtbWFrcm9uYS12c3RyZXR5dHNpYS12by1mcmFudHN5edIBamh0dHBzOi8va29ycmVzcG9uZGVudC5uZXQvYW1wLzQ0NDkzNTEtcHV0eW4teS1iYWlkZW4tcHJ5bmlhbHktcHJlZGxvemhlbnllLW1ha3JvbmEtdnN0cmV0eXRzaWEtdm8tZnJhbnRzeXk?oc=5" target="_blank">Путин и Байден приняли предложение Макрона встретиться во Франции</a>&nbsp;&nbsp;<font color="#6f6f6f">Корреспондент.net</font></li><li><a href="https://news.google.com/__i/rss/rd/articles/CBMiS2h0dHBzOi8vZHVtc2theWEubmV0L25ld3MvemVsZW5za2l5LWktbWFrcm9uLXZ5c3R1cGlsaS16YS1zcm9jaG55eS1zb3p5di10L9IBAA?oc=5" target="_blank">Зеленский и Макрон выступили за срочный созыв ТКГ | Новости Одессы</a>&nbsp;&nbsp;<font color="#6f6f6f">Думская.net</font></li><li><a href="https://news.google.com/__i/rss/rd/articles/CBMiNmh0dHBzOi8vd3d3LnByYXZkYS5jb20udWEvcnVzL25ld3MvMjAyMi8wMi8yMC83MzI0NzEzL9IBAA?oc=5" target="_blank">Макрон и Путин договорились созвать саммит по безопасности и попытаться остановить огонь</a>&nbsp;&nbsp;<font color="#6f6f6f">Украинская правда</font></li><li><a href="https://news.google.com/__i/rss/rd/articles/CBMiWGh0dHBzOi8va29ycmVzcG9uZGVudC5uZXQvd29ybGQvNDQ0OTMzNi1kemhvbnNvbi1kYWwtb3RzZW5rdS1yYXpnaG92b3J1LW1ha3JvbmEteS1wdXR5bmHSAVZodHRwczovL2tvcnJlc3BvbmRlbnQubmV0L2FtcC80NDQ5MzM2LWR6aG9uc29uLWRhbC1vdHNlbmt1LXJhemdob3ZvcnUtbWFrcm9uYS15LXB1dHluYQ?oc=5" target="_blank">Джонсон дал оценку разговору Макрона и Путина</a>&nbsp;&nbsp;<font color="#6f6f6f">Корреспондент.net</font></li><li><strong><a href="https://news.google.com/stories/CAAqNggKIjBDQklTSGpvSmMzUnZjbmt0TXpZd1NoRUtEd2pPMjRMc0JCRnlGdWxNM3g1TUZDZ0FQAQ?oc=5" target="_blank">Посмотреть в приложении "Google Новости"</a></strong></li></ol></description>
        <source url="https://www.pravda.com.ua">Украинская правда</source>
        </item>
        <item>
        <title>В Украине 127 COVID-смертей за сутки - Корреспондент.net</title>
        <link>https://news.google.com/__i/rss/rd/articles/CBMiTmh0dHBzOi8va29ycmVzcG9uZGVudC5uZXQvdWtyYWluZS80NDQ5MzcwLXYtdWtyYXluZS0xMjctQ09WSUQtc21lcnRlaS16YS1zdXRredIBSmh0dHBzOi8va29ycmVzcG9uZGVudC5uZXQvYW1wLzQ0NDkzNzAtdi11a3JheW5lLTEyNy1DT1ZJRC1zbWVydGVpLXphLXN1dGt5?oc=5</link>
        <guid isPermaLink="false">463423721</guid>
        <pubDate>Mon, 21 Feb 2022 06:44:00 GMT</pubDate>
        <description><ol><li><a href="https://news.google.com/__i/rss/rd/articles/CBMiTmh0dHBzOi8va29ycmVzcG9uZGVudC5uZXQvdWtyYWluZS80NDQ5MzcwLXYtdWtyYXluZS0xMjctQ09WSUQtc21lcnRlaS16YS1zdXRredIBSmh0dHBzOi8va29ycmVzcG9uZGVudC5uZXQvYW1wLzQ0NDkzNzAtdi11a3JheW5lLTEyNy1DT1ZJRC1zbWVydGVpLXphLXN1dGt5?oc=5" target="_blank">В Украине 127 COVID-смертей за сутки</a>&nbsp;&nbsp;<font color="#6f6f6f">Корреспондент.net</font></li><li><a href="https://news.google.com/__i/rss/rd/articles/CBMiNmh0dHBzOi8vd3d3LnByYXZkYS5jb20udWEvcnVzL25ld3MvMjAyMi8wMi8yMS83MzI0NzQ0L9IBAA?oc=5" target="_blank">Covid в Украине: волна идет на спад, в Киеве ситуация самая плохая</a>&nbsp;&nbsp;<font color="#6f6f6f">Украинская правда</font></li><li><a href="https://news.google.com/__i/rss/rd/articles/CBMibmh0dHBzOi8vZHAuaW5mb3JtYXRvci51YS8yMDIyLzAyLzIwL2tvcm9uYXZpcnVzLXYtZG5lcHJlLWktb2JsYXN0aS0xLTA3Ny1jaGVsb3Zlay16YWJvbGVsaS16YS1wb3NsZWRuaWUtc3V0a2kv0gEA?oc=5" target="_blank">Коронавирус в Днепре и области: 1 077 человек заболели за последние сутки</a>&nbsp;&nbsp;<font color="#6f6f6f">Информатор Днепр</font></li><li><a href="https://news.google.com/__i/rss/rd/articles/CBMiZGh0dHBzOi8vY29yb25hdmlydXMucmJjLnVhL3J1cy9uZXdzL2tvcm9uYXZpcnVzb20tdWtyYWluZS16YXJhemlsaXMtMTMtNTYyLWNoZWxvdmVrYS0xNjQ1NDI0Mjc4Lmh0bWzSAWhodHRwczovL2Nvcm9uYXZpcnVzLnJiYy51YS9ydXMvbmV3cy9rb3JvbmF2aXJ1c29tLXVrcmFpbmUtemFyYXppbGlzLTEzLTU2Mi1jaGVsb3Zla2EtMTY0NTQyNDI3OC5odG1sL2FtcA?oc=5" target="_blank">Коронавирусом в Украине заразились 13 562 человека, - суточная статистика</a>&nbsp;&nbsp;<font color="#6f6f6f">РБК Украина</font></li><li><a href="https://news.google.com/__i/rss/rd/articles/CBMiJ2h0dHBzOi8vbmlrdmVzdGkuY29tL25ld3MvcHVibGljLzI0MTI4NtIBAA?oc=5" target="_blank">В Украине за сутки обнаружили 13,5 тысячи новых COVID-случаев</a>&nbsp;&nbsp;<font color="#6f6f6f">НикВести - новости николаева</font></li><li><strong><a href="https://news.google.com/stories/CAAqNggKIjBDQklTSGpvSmMzUnZjbmt0TXpZd1NoRUtEd2pwa2YzY0FSR1dYUURyOERSbXhpZ0FQAQ?oc=5" target="_blank">Посмотреть в приложении "Google Новости"</a></strong></li></ol></description>
        <source url="https://korrespondent.ru">Корреспондент.net</source>
        </item>
      </channel>
    </rss>
  ''';

  test('news are parsed correctly and russian news are filtered out', () {
    final newsPieces = NewsSearchRepository().parseNewsFromXml(rawXml);
    expect(newsPieces.length, equals(1)); // russian piece is filtered out

    final piece = newsPieces[0];
    expect(
        piece.link,
        equals('https://news.google.com/__i/rss/rd/articles'
            '/CBMiNmh0dHBzOi8vd3d3LnByYXZkYS5jb20udWEvcnV'
            'zL25ld3MvMjAyMi8wMi8yMS83MzI0NzM4L9IBAA?oc=5'));
    expect(
        piece.title,
        equals(
            'Байден и Путин согласились на участие в саммите по вопросам безопасности'));
    expect(piece.sourceName, equals('Украинская правда'));
    expect(piece.sourceLink, equals('https://www.pravda.com.ua'));
    expect(piece.pubDate, equals(DateTime.utc(2022, 02, 21, 01, 59, 09)));
    expect(piece.isSaved, equals(false));
  });
}
