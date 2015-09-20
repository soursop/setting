# Slick
### SQL을 불러오는 방법
* Plain SQL
 * String Interpolation을 사용해 raw sql을 사용할수 있다
 * 결과는 slick.jdbc.GetResult로 리턴을 해주는데, 이 결과값을 object 값으로 변환해주는 매퍼가 implicit으로 들어가 있어서
 String이나 Int 같은 일반적인 값이 아니면, 명시적으로 매퍼를 정의해 넣어 주어야 한다. (삽질했다...)
 
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

* Object Mapping
