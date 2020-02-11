# Spring笔记

## Spring注解

### @Scope

​	在多数情况，我们只会使用singleton和prototype两种scope，如果在spring配置文件内未指定scope属性，默认为singleton

#### singleton

​	表示在spring容器中的单例，通过spring容器获得该bean时总是返回唯一的实例

#### prototype

​	表示每次获得bean都会生成一个新的对象

#### request

​	表示在一次http请求内有效（只适用于web应用）

#### session

​	表示在一个用户会话内有效（只适用于web应用）

#### globalSession

​	表示在全局会话内有效（只适用于web应用）

### @Configuration

​	用于定义配置类，可替换xml配置文件，被注解的类内部包含有一个或多个被@Bean注解的方法，这些方法将会被AnnotationConfigApplicationContext或AnnotationConfigWebApplicationContext类进行扫描，并用于构建bean定义，初始化Spring容器

### @ConditionalOnProperty

​	控制某个configuration是否生效。通过内部两个属性name和havingValue来判断条件，其中name用来从application.properties中读取某个属性值，如果该值为空，则返回false；如果值不为空，则将该值与havingValue指定的值进行比较，如果一样则返回true，否则返回false。只有判断结果为true时，当前configuration才生效。

### @ComponentScan

​	指定spring容器扫描路径，配合@Configuration注解一起使用

### @Profile

​	通过spring.profiles.active属性的值判断是否加载当前bean至容器中，value属性为String数组。

```java
@Profile({"dev","test"})
```

## Swagger

### 配置

```java
/**
 * 表示只有dev环境和test环境当前设置才生效，通过spring.profiles.active属性指定
 */
@Profile({"dev", "test"})
@Configuration
@EnableSwagger2
public class SwaggerConfig {
    
    @Bean
    public Docket createRestApi() {
        return new Docket(DocumentationType.SWAGGER_2)
                .apiInfo(apiInfo())
                .select()
                .apis(RequestHandlerSelectors.basePackage("com.solitude"))
                .paths(PathSelectors.any())
                .build();
    }

    private ApiInfo apiInfo() {
        return new ApiInfoBuilder()
                .title("我是页面标题")
                .contact(new Contact("我是创建人张三","",""))
                .description("我的项目描述")
                .version("我是版本号")
                .build();
    }
    
}
```

### 注解

#### @Api

​	作用于接口类上，将一个接口类标记为Swagger资源。

#### @ApiOperation

​	描述针对特定路径的操作或通常为HTTP方法。可以用tags参数进行分组，如果没有设置tags参数，所有接口方法通过所在接口类进行分组。

#### @ApiImplicitParams

​	包装器，允许包含多个{@link ApiImplicitParam}对象的列表。

#### @ApiImplicitParam

​	表示API操作中的单个参数。

​	name：参数名

​	value：参数说明

​	required：是否必须

​	paramType：参数所在请求位置

​		header  --> 请求参数的获取：@RequestHeader

​		query   --> 请求参数的获取：@RequestParam

​		path    --> 请求参数的获取：@PathVariable

​		body（不常用）

​		form（不常用）

​	dataType：参数类型，默认String

​	defaultValue：参数的默认值

#### @ApiModel

​	提供有关Swagger模型的信息，作用于参数对象，描述对象信息。

#### @ApiModelProperty

​	添加和操作模型属性的数据。

​	hidden：是否展示当前属性，默认扫描@ApiModel类中的全部参数

​	example：参数模板



​	

​	