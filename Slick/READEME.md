# Slick

### Query

* Plain SQL
 * String Interpolation을 사용해 raw sql을 사용할수 있다
 * 결과는 slick.jdbc.GetResult로 리턴을 해주는데, 이 결과값을 object 값으로 변환해주는 매퍼가 implicit으로 들어가 있어서
String이나 Int 같은 일반적인 값이 아니면, 명시적으로 매퍼를 정의해 넣어 주어야 한다. (삽질했다...) 
아래와 같은 코드가 있다고 해보자

example of coffees

    import scala.concurrent.ExecutionContext.Implicits.global
    import slick.driver.H2Driver.api._
    import slick.jdbc.GetResult
    
    // Definition of the COFFEES table
    class Coffees(tag: Tag) extends Table[Coffee](tag, "COFFEES") {
      def name = column[String]("COF_NAME", O.PrimaryKey)
      def supID = column[Int]("SUP_ID")
      def price = column[Double]("PRICE")
      def sales = column[Int]("SALES")
      def total = column[Int]("TOTAL")
      def * = (name, supID, price, sales, total) <> (Coffee.tupled, Coffee.unapply)
      // A reified foreign key relation that can be navigated to create a join
      def supplier = foreignKey("SUP_FK", supID, suppliers)(_.id)
    }
    sql"select * from COFFEES where COFFEES = $name".as[Coffee].headOption

위의 코드만 적어 넣으면 에러가 난다. 이유는

    case class SQLActionBuilder(queryParts: Seq[Any], unitPConv: SetParameter[Unit]) {
      def as[R](implicit rconv: GetResult[R]): SqlStreamingAction[Vector[R], R, Effect] = {
        val query =
          if(queryParts.length == 1 && queryParts(0).isInstanceOf[String]) queryParts(0).asInstanceOf[String]
          else queryParts.iterator.map(String.valueOf).mkString
        new StreamingInvokerAction[Vector[R], R, Effect] {
          def statements = List(query)
          protected[this] def createInvoker(statements: Iterable[String]) = new StaticQueryInvoker[Unit, R](statements.head, unitPConv, (), rconv)
          protected[this] def createBuilder = Vector.newBuilder[R]
        }
      }
      def asUpdate = as[Int](GetResult.GetUpdateValue).head
    }

쿼리를 만들어 주는 SQLActionBuilder에서 as를 사용할때 리턴 받고자 하는 GetResult를 implicit으로 받아야 하기 때문이다. 따라서

    implicit val getCoffeeResult = GetResult(r => Coffee(r.<<, r.<<, r.<<, r.<<, r.<<))

위와 같이 GetResult를 implicit으로 정의를 해주어야만 정상적으로 값이 리턴이 된다.

* Object Mapping
