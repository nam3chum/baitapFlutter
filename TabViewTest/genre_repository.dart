import 'Model/genre.dart';

class GenreRepository {
  static final Genre tienHiep = Genre(name: "Tiên Hiệp");
  static final Genre huyenHuyen = Genre(name: "Huyền Huyễn");
  static final Genre kiemHiep = Genre(name: "Kiếm Hiệp");
  static final Genre doThi = Genre(name: "Đô Thị");
  static final Genre xuyenKhong = Genre(name: "Xuyên Không");
  static final Genre trinhTham = Genre(name: "Trinh Thám");

  static final List<Genre> all = [tienHiep, huyenHuyen, kiemHiep, doThi, xuyenKhong, trinhTham];
}
