package com.example.hello;

import com.workshop.case5.models.HelloWorldResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.workshop.case5.HelloApi;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.enums.ParameterIn;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Size;

@RestController
public class HelloController implements HelloApi {

    @Override
    public ResponseEntity<HelloWorldResponse> hello(@Parameter(name = "who",description = "",in = ParameterIn.QUERY) @RequestParam(value = "who",required = false, defaultValue = "world") @Size(
        min = 1,
        max = 100
    ) @Valid String who) throws Exception {
        HelloWorldResponse dto = new HelloWorldResponse();
        dto.setHello(who);
        return ResponseEntity.ok(dto);
    }
}
